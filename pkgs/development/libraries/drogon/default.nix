{ stdenv, fetchFromGitHub, cmake, jsoncpp, libossp_uuid, zlib, lib, fetchpatch
# optional but of negligible size
, openssl, brotli, c-ares
# optional databases
, sqliteSupport ? true, sqlite
, postgresSupport ? false, postgresql
, redisSupport ? false, hiredis
, mysqlSupport ? false, libmysqlclient, mariadb }:

stdenv.mkDerivation (finalAttrs: {
  pname = "drogon";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "drogonframework";
    repo = "drogon";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-6F+LRcoBqHEbweqbVFHlR3I9nj1NaYty8zKcR4ZHKxg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_TESTING=${if finalAttrs.finalPackage.doInstallCheck then "ON" else "OFF"}"
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
    # drogon uses mariadb for mysql (see https://github.com/drogonframework/drogon/wiki/ENG-02-Installation#Library-Dependencies)
    ++ lib.optionals mysqlSupport [ libmysqlclient mariadb ];

  patches = [
    # this part of the test would normally fail because it attempts to configure a CMake project that uses find_package on itself
    # this patch makes drogon and trantor visible to the test
    ./fix_find_package.patch
  ];

  # modifying PATH here makes drogon_ctl visible to the test
  installCheckPhase = ''
    (
      cd ..
      PATH=$PATH:$out/bin $SHELL test.sh
    )
  '';

  # this excludes you, pkgsStatic (cmake wants to run built binaries
  # in the buildPhase)
  doInstallCheck = stdenv.buildPlatform == stdenv.hostPlatform;

  meta = with lib; {
    homepage = "https://github.com/drogonframework/drogon";
    description = "C++14/17 based HTTP web application framework";
    license = licenses.mit;
    maintainers = with maintainers; [ urlordjames ];
    platforms = platforms.all;
  };
})
