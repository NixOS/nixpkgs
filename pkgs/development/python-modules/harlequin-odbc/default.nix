{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  hatchling,
  duckdb,
  pyodbc,
}:
buildPythonPackage (finalAttrs: {
  pname = "harlequin-odbc";
  version = "0.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "harlequin-odbc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U0z7fgBzdL+PRhll6AH4DziqY26kVYA4qkOEbZbWF1g=";
  };

  build-system = [
    hatchling
  ];

  # harlequin loads this adapter as a plugin, so depending on harlequin would
  # create a cycle, as harlequin can depend on this package.
  pythonRemoveDeps = [
    "harlequin"
  ];

  dependencies = [
    pyodbc
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    duckdb
  ];

  # The test suite needs harlequin (removed above) and a live database
  # reachable over ODBC.
  doCheck = false;

  meta = {
    description = "A Harlequin adapter for ODBC drivers";
    homepage = "https://github.com/tconbeer/harlequin-odbc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      c4patino
    ];
  };
})
