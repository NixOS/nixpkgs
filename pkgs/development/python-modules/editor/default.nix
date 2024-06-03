{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  runs,
  xmod,
  pytestCheckHook,
  tdir,
}:

buildPythonPackage rec {
  pname = "editor";
  version = "1.6.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rec";
    repo = "editor";
    rev = "v${version}";
    hash = "sha256-FVtat3gUsK5Lv6XSkVXj0hY6NkMGw6LxRWMJrZ/cIis=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    runs
    xmod
  ];

  nativeCheckInputs = [
    pytestCheckHook
    tdir
  ];

  pythonImportsCheck = [ "editor" ];

  meta = with lib; {
    description = "Open the default text editor";
    homepage = "https://github.com/rec/editor";
    changelog = "https://github.com/rec/editor/blob/${src.rev}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
