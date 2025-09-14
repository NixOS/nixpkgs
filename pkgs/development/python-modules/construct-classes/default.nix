{
  lib,
  buildPythonPackage,
  construct,
  fetchFromGitHub,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage rec {
  pname = "construct-classes";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matejcik";
    repo = "construct-classes";
    tag = "v${version}";
    hash = "sha256-goOQMt/nVjWXYltpnKHtJaLOhR+gRTmtoUh7zVb7go4=";
  };

  build-system = [ uv-build ];

  dependencies = [ construct ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "construct_classes" ];

  meta = with lib; {
    description = "Parse your binary data into dataclasses";
    homepage = "https://github.com/matejcik/construct-classes";
    changelog = "https://github.com/matejcik/construct-classes/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
