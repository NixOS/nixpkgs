{ stdenv, fetchurl, python, bzip2, zlib, gmp, openssl, boost
# Passed by version specific builders
, baseVersion, revision, sha256
, extraConfigureFlags ? ""
, postPatch ? null
, darwin
, ...
}:

stdenv.mkDerivation rec {
  name = "botan-${version}";
  version = "${baseVersion}.${revision}";

  src = fetchurl {
    name = "Botan-${version}.tgz";
    urls = [
       "http://files.randombit.net/botan/v${baseVersion}/Botan-${version}.tgz"
       "http://botan.randombit.net/releases/Botan-${version}.tgz"
    ];
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
  passthru.updateInfo.downloadPage = "http://files.randombit.net/botan/";
}
