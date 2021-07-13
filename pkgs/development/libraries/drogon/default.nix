{ stdenv, fetchFromGitHub, cmake, jsoncpp, libossp_uuid, zlib, openssl, lib
# miscellaneous
, brotli, c-ares
# databases
, sqliteSupport ? true, sqlite
, postgresSupport ? false, postgresql
, redisSupport ? false, hiredis
, mysqlSupport ? false, libmysqlclient, mariadb }:

stdenv.mkDerivation rec {
  pname = "drogon";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "an-tao";
    repo = "drogon";
    rev = "v${version}";
    sha256 = "0rhwbz3m5x3vy5zllfs8r347wqprg29pff5q7i53f25bh8y0n49i";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_TESTING=${if doInstallCheck then "ON" else "OFF"}"
    "-DBUILD_EXAMPLES=OFF"
  ];

  propagatedBuildInputs = [
    jsoncpp
    libossp_uuid
    zlib
    openssl
    brotli
    c-ares
  ] ++ lib.optional sqliteSupport sqlite
    ++ lib.optional postgresSupport postgresql
    ++ lib.optional redisSupport hiredis
    # drogon uses mariadb for mysql (see https://github.com/an-tao/drogon/wiki/ENG-02-Installation#Library-Dependencies)
    ++ lib.optional mysqlSupport [ libmysqlclient mariadb ];

  patches = [
    # this part of the test would normally fail because it attempts to configure a CMake project that uses find_package on itself
    # this patch makes drogon and trantor visible to the test
    ./fix_find_package.patch
  ];

  # modifying PATH here makes drogon_ctl visible to the test
  installCheckPhase = ''
    cd ..
    patchShebangs test.sh
    PATH=$PATH:$out/bin ./test.sh
  '';

  doInstallCheck = true;

  meta = with lib; {
    homepage = "https://github.com/an-tao/drogon";
    description = "C++14/17 based HTTP web application framework";
    license = licenses.mit;
    maintainers = [ maintainers.urlordjames ];
    platforms = platforms.all;
  };
}
