{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "miltertest";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "flowerysong";
    repo = "miltertest";
    tag = "v${version}";
    hash = "sha256-8KpuIR+UxRcJbb2pwKDOkSmyXovlyOa4DpeUDn1oK0Y=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "miltertest" ];

  meta = {
    description = "Pure python implementation of the milter protocol";
    homepage = "https://github.com/flowerysong/miltertest";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ lucasbergman ];
  };
}
