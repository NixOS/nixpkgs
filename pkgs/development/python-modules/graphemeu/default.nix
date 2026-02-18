{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "graphemeu";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "timendum";
    repo = "grapheme";
    tag = "v${version}";
    hash = "sha256-qDspbeOmlfQ4VLPdKEuxNPYilKjwUcAJiEOMfx9fFlI=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "grapheme" ];

  meta = {
    description = "Python package for grapheme aware string handling";
    homepage = "https://github.com/timendum/grapheme";
    changelog = "https://github.com/timendum/grapheme/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
}
