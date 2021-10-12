{ lib, buildPecl, fetchFromGitHub, writeText, libcouchbase, zlib, php, substituteAll }:
let
  pname = "couchbase";
  version = "3.2.0";
in
buildPecl {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "couchbase";
    repo = "php-couchbase";
    rev = "v${version}";
    sha256 = "sha256-rvlyH28xWLIVwK3yqqdhkoD1h6kl8FDq3Byo7mhV3jM=";
  };

  configureFlags = [ "--with-couchbase" ];

  buildInputs = [ libcouchbase zlib ];
  internalDeps = lib.optionals (lib.versionOlder php.version "8.0") [ php.extensions.json ];

  patches = [
    (substituteAll {
      src = ./libcouchbase.patch;
      inherit libcouchbase;
    })
  ];

  meta = with lib; {
    description = "Couchbase Server PHP extension";
    license = licenses.asl20;
    homepage = "https://docs.couchbase.com/php-sdk/current/project-docs/sdk-release-notes.html";
    maintainers = teams.php.members;
  };
}
