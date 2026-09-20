{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  beancount_2,
  beancount-data,
  click,
  orjson,
  pgcopy,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "beancount-exporter";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beancount-exporter";
    tag = version;
    hash = "sha256-n2sNFOl5o16UWCrfwi2yv/amCTswoniY6xR4jPO76/w=";
  };

  build-system = [ poetry-core ];

  # Upstream depends on LaunchPlatform/pgcopy-standalone, a fork of pgcopy 1.6.0.
  # nixpkgs packages altaurog/pgcopy instead, which provides the same `pgcopy` module.
  pythonRemoveDeps = [ "pgcopy-standalone" ];

  dependencies = [
    beancount_2
    beancount-data
    click
    orjson
    pgcopy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Requires a running PostgreSQL instance
    "tests/test_pgcopy.py"
    "tests/db"
  ];

  pythonImportsCheck = [ "beancount_exporter" ];

  meta = {
    description = "Command line tool for exporting Beancount data as JSON";
    homepage = "https://github.com/LaunchPlatform/beancount-exporter";
    changelog = "https://github.com/LaunchPlatform/beancount-exporter/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fangpen ];
  };
}
