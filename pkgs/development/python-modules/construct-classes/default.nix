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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.13,<0.9.0" "uv_build>=0.8.13"
  '';

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.13,<0.10.0" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [ construct ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "construct_classes" ];

  meta = {
    description = "Parse your binary data into dataclasses";
    homepage = "https://github.com/matejcik/construct-classes";
    changelog = "https://github.com/matejcik/construct-classes/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
