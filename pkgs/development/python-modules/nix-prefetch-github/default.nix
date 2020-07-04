{ fetchPypi
, lib
, buildPythonPackage
, pythonOlder
, attrs
, click
, effect
, jinja2
, git
, pytestCheckHook
, pytest-black
, pytestcov
, pytest-isort
}:

buildPythonPackage rec {
  pname = "nix-prefetch-github";
  version = "2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PVB/cL0NVB5pHxRMjg8TLatvIvHjfCvaRWBanVHYT+E=";
  };

  # The tests for this package require nix and network access.  That's
  # why we cannot execute them inside the building process.
  doCheck = false;

  propagatedBuildInputs = [
    attrs
    click
    effect
    jinja2
  ];

  checkInputs = [ pytestCheckHook pytest-black pytestcov pytest-isort git ];

  # latest version of isort will cause tests to fail
  # ignore tests which are impure
  disabledTests = [ "isort" "life" "outputs" "fetch_submodules" ];

  meta = with lib; {
    description = "Prefetch sources from github";
    homepage = "https://github.com/seppeljordan/nix-prefetch-github";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seppeljordan ];
  };
}
