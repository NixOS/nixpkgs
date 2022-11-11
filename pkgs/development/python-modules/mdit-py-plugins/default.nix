{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, markdown-it-py
, pytest-regressions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mdit-py-plugins";
  version = "0.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3zFSTjqwjUV6+fU6falYbIzj/Hp7E/9EXKZIi00tkg4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    markdown-it-py
  ];

  checkInputs = [
    pytestCheckHook
    pytest-regressions
  ];

  pythonImportsCheck = [
    "mdit_py_plugins"
  ];

  meta = with lib; {
    description = "Collection of core plugins for markdown-it-py";
    homepage = "https://github.com/executablebooks/mdit-py-plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
