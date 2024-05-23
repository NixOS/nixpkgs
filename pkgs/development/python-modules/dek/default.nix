{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  xmod,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dek";
  version = "1.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rec";
    repo = "dek";
    rev = "v${version}";
    hash = "sha256-DYODdImTRCukGmGbkZ+9TQeI9DYaeRd/EHS6VND5IDs=";
  };

  build-system = [ poetry-core ];

  dependencies = [ xmod ];

  nativeBuildInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dek" ];

  meta = with lib; {
    description = "The decorator-decorator";
    homepage = "https://github.com/rec/dek";
    changelog = "https://github.com/rec/dek/blob/${src.rev}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
