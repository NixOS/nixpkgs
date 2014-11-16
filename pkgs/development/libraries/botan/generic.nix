{ stdenv, fetchurl, python, bzip2, zlib, gmp, openssl, boost
# Passed by version specific builders
, baseVersion, revision, sha256
, ...
}:

stdenv.mkDerivation rec {
  name = "botan-${version}";
  version = "${baseVersion}.${revision}";

  src = fetchurl {
    name = "Botan-${version}.tar.bz2";
    url = "http://files.randombit.net/botan/v${baseVersion}/Botan-${version}.tbz";
    inherit sha256;
  };

  buildInputs = [ python bzip2 zlib gmp openssl boost ];

  configurePhase = ''
    python configure.py --prefix=$out --with-gnump --with-bzip2 --with-zlib --with-openssl
  '';

  postInstall = ''
    cd "$out"/lib/pkgconfig
    ln -s botan-*.pc botan.pc || true
  '';

  meta = with stdenv.lib; {
    description = "Cryptographic algorithms library";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
    license = licenses.bsd2;
  };
  passthru.updateInfo.downloadPage = "http://files.randombit.net/botan/";
}
