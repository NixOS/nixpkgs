{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  flit-core,
  markdown-it-py,
  pytest-regressions,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mdit-py-plugins";
  version = "0.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-YBJu0vIOD747DrJLcqiZMHq34+gHdXeGLCw1OxxzIJ0=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ markdown-it-py ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-regressions
  ];

  pythonImportsCheck = [ "mdit_py_plugins" ];

  meta = with lib; {
    description = "Collection of core plugins for markdown-it-py";
    homepage = "https://github.com/executablebooks/mdit-py-plugins";
    changelog = "https://github.com/executablebooks/mdit-py-plugins/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
