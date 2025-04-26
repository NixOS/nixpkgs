{
  lib,
  buildPecl,
  fetchFromGitHub,
  libcouchbase,
  zlib,
  replaceVars,
  php,
}:
let
  pname = "couchbase";
  version = "3.2.2";
in
buildPecl {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "couchbase";
    repo = "php-couchbase";
    rev = "v${version}";
    sha256 = "sha256-JpzLR4NcyShl2VTivj+15iAsTTsZmdMIdZYc3dLCbIA=";
  };

  configureFlags = [ "--with-couchbase" ];

  buildInputs = [
    libcouchbase
    zlib
  ];

  patches = [
    (replaceVars ./libcouchbase.patch {
      inherit libcouchbase;
    })
  ];

  meta = with lib; {
    changelog = "https://github.com/couchbase/php-couchbase/releases/tag/v${version}";
    description = "Couchbase Server PHP extension";
    license = licenses.asl20;
    homepage = "https://docs.couchbase.com/php-sdk/current/project-docs/sdk-release-notes.html";
    teams = [ teams.php ];
    broken = lib.versionAtLeast php.version "8.3";
  };
}
