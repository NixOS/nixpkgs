{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, nodejs
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pscript";
  version = "0.7.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "flexxui";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-AhVI+7FiWyH+DfAXnau4aAHJAJtsWEpmnU90ey2z35o=";
  };

  checkInputs = [
    pytestCheckHook
    nodejs
  ];

  preCheck = ''
    # do not execute legacy tests
    rm -rf pscript_legacy
  '';

  pythonImportsCheck = [
    "pscript"
  ];

  meta = with lib; {
    description = "Python to JavaScript compiler";
    homepage = "https://pscript.readthedocs.io";
    changelog = "https://github.com/flexxui/pscript/blob/v${version}/docs/releasenotes.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
