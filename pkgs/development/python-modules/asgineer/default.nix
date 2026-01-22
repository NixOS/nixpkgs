{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  flit-core,
}:

buildPythonPackage rec {
  pname = "asgineer";
  version = "0.9.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "almarklein";
    repo = "asgineer";
    tag = "v${version}";
    hash = "sha256-8qI5eHt+UmQGZNCn12Iup9dIVd+aI6r3Z1R+u+SziMc=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [ "asgineer" ];

  meta = {
    description = "Really thin ASGI web framework";
    homepage = "https://asgineer.readthedocs.io";
    changelog = "https://github.com/almarklein/asgineer/releases/tag/v${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
}
