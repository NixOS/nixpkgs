{ stdenv, fetchurl
, cxxSupport ? true
, compat185 ? true

# Options from inherited versions
, version, sha256
, extraPatches ? [ ]
, license ? "Berkeley Database License"
}:

stdenv.mkDerivation rec {
  name = "db-${version}";

  src = fetchurl {
    url = "http://download.oracle.com/berkeley-db/${name}.tar.gz";
    sha256 = sha256;
  };
  
  patches = extraPatches;

  configureFlags = [
    (if cxxSupport then "--enable-cxx" else "--disable-cxx")
    (if compat185 then "--enable-compat185" else "--disable-compat185")
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
    license = license;
    platforms = platforms.unix;
  };
}
