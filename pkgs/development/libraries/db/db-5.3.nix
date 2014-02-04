{ stdenv, fetchurl
, cxxSupport ? true
}:

stdenv.mkDerivation rec {
  name = "db-5.3.28";

  src = fetchurl {
    url = "http://download.oracle.com/berkeley-db/${name}.tar.gz";
    sha256 = "0a1n5hbl7027fbz5lm0vp0zzfp1hmxnz14wx3zl9563h83br5ag0";
  };

  configureFlags = [
    (if cxxSupport then "--enable-cxx" else "--disable-cxx")
  ];

  preConfigure = ''
    cd build_unix
    configureScript=../dist/configure
  '';

  postInstall = ''
    rm -rf $out/docs
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.oracle.com/technetwork/database/database-technologies/berkeleydb/index.html";
    description = "Berkeley DB";
    license = "Berkeley Database License";
    platforms = platforms.unix;
  };
}
