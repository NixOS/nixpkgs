{ lib, stdenv, fetchurl
, cxxSupport ? true
, compat185 ? true
, dbmSupport ? false

# Options from inherited versions
, version, sha256
, extraPatches ? [ ]
, license ? lib.licenses.sleepycat
, drvArgs ? {}
}:

stdenv.mkDerivation (rec {
  pname = "db";
  inherit version;

  src = fetchurl {
    url = "https://download.oracle.com/berkeley-db/${pname}-${version}.tar.gz";
    sha256 = sha256;
  };

  patches = extraPatches;

  outputs = [ "bin" "out" "dev" ];

  configureFlags =
    [
      (if cxxSupport then "--enable-cxx" else "--disable-cxx")
      (if compat185 then "--enable-compat185" else "--disable-compat185")
    ]
    ++ lib.optional dbmSupport "--enable-dbm"
    ++ lib.optional stdenv.isFreeBSD "--with-pic";

  preConfigure = ''
    cd build_unix
    configureScript=../dist/configure
  '';

  postInstall = ''
    rm -rf $out/docs
  '';

  enableParallelBuilding = true;

  doCheck = true;

  checkPhase = ''
    make examples_c examples_cxx
  '';

  meta = with lib; {
    homepage = "http://www.oracle.com/technetwork/database/database-technologies/berkeleydb/index.html";
    description = "Berkeley DB";
    license = license;
    platforms = platforms.unix;
  };
} // drvArgs)
