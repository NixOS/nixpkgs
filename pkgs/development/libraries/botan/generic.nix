{ stdenv, fetchFromGitHub, python, bzip2, zlib, gmp, openssl, boost
# Passed by version specific builders
, version, sha256
, extraConfigureFlags ? ""
, postPatch ? null
, darwin
, ...
}:

stdenv.mkDerivation rec {
  pname = "botan";
  inherit version;

  src = fetchFromGitHub {
    owner = "randombit";
    repo = "botan";
    rev = version;
    inherit sha256;
  };

  inherit postPatch;

  buildInputs = [ python bzip2 zlib gmp openssl boost ]
             ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  configurePhase = ''
    python configure.py --prefix=$out --with-bzip2 --with-zlib ${if openssl != null then "--with-openssl" else ""} ${extraConfigureFlags}${if stdenv.cc.isClang then " --cc=clang" else "" }
  '';

  enableParallelBuilding = true;

  preInstall = ''
    if [ -d src/scripts ]; then
      patchShebangs src/scripts
    fi
  '';

  postInstall = ''
    cd "$out"/lib/pkgconfig
    ln -s botan-*.pc botan.pc || true
  '';

  meta = with stdenv.lib; {
    inherit version;
    description = "Cryptographic algorithms library";
    maintainers = with maintainers; [ raskin ];
    platforms = ["x86_64-linux" "i686-linux" "x86_64-darwin"];
    license = licenses.bsd2;
  };
}
