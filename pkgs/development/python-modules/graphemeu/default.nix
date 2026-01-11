{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "graphemeu";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "timendum";
    repo = "grapheme";
    tag = "v${version}";
    hash = "sha256-CZVF9djk9iIVD/6gJZ+HbZt6O91hR7xdz52bhdnghE0=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "grapheme" ];

  meta = {
    description = "Python package for grapheme aware string handling";
    homepage = "https://github.com/timendum/grapheme";
    changelog = "https://github.com/timendum/grapheme/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
}
