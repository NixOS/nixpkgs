{ lib, buildPecl, fetchFromGitHub, zlib, cmake, pkg-config, openssl_1_1, php }:
let
  version = "4.1.4";
  pname = "couchbase";
in
buildPecl {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "couchbase";
    repo = "couchbase-php-client";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-twu3zYhSCAvjZJl/fp4vzkE4PHw23QzCkfEt6ZOIRtw=";
  };

  dontUseCmakeConfigure = true;

  env.COUCHBASE_CMAKE_EXTRA = "-DCOUCHBASE_CXX_CLIENT_EMBED_MOZILLA_CA_BUNDLE=false";

  configureFlags = [ "--enable-couchbase" ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ php zlib openssl_1_1 ];

  meta = {
    changelog = "https://pecl.php.net/package-info.php?package=couchbase&version=${version}";
    description = "Couchbase Server PHP extension";
    homepage = "https://pecl.php.net/package/couchbase";
    license = lib.licenses.asl20;
    maintainers = lib.teams.php.members;
  };
}
