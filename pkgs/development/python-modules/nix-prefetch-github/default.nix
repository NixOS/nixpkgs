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
  version = "4.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "asfRohjOgYxMV/wprKvxUD328GVJQkAYnuAkE09kKgs=";
  };

  propagatedBuildInputs = [
    attrs
    click
    effect
    jinja2
  ];

  checkInputs = [ pytestCheckHook pytest-black pytestcov pytest-isort git ];
  checkPhase = ''
    pytest -m 'not network'
  '';

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
