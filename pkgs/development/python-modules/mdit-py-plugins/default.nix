{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, markdown-it-py
, pytest-regressions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mdit-py-plugins";
  version = "0.2.8";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MXQjaVDuguGbmby6BQnrTdpq6Mih3HabXuyFxf9jB18=";
  };

  propagatedBuildInputs = [ markdown-it-py ];

  checkInputs = [ pytestCheckHook pytest-regressions ];
  pythonImportsCheck = [ "mdit_py_plugins" ];

  meta = with lib; {
    description = "Collection of core plugins for markdown-it-py";
    homepage = "https://github.com/executablebooks/mdit-py-plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
