{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  hatchling,
  duckdb,
  mysql-connector-python,
}:
buildPythonPackage (finalAttrs: {
  pname = "harlequin-mysql";
  version = "1.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "harlequin-mysql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iaVVYRLWnuwH2huEW/mpzN+BD36S8tdPxWvupwUsxY0=";
  };

  build-system = [
    hatchling
  ];

  # harlequin loads this adapter as a plugin, so depending on harlequin would
  # create a cycle, as harlequin can depend on this package.
  pythonRemoveDeps = [
    "harlequin"
  ];

  # The requirement is <10, but nixpkgs only ships newer major versions.
  pythonRelaxDeps = [
    "mysql-connector-python"
  ];

  dependencies = [
    mysql-connector-python
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    duckdb
  ];

  # The test suite needs harlequin (removed above) and a live MySQL server.
  doCheck = false;

  meta = {
    description = "A Harlequin adapter for MySQL and MariaDB";
    homepage = "https://github.com/tconbeer/harlequin-mysql";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      c4patino
    ];
  };
})
