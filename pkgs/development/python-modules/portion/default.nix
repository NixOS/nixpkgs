{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  sortedcontainers,

  # tests
  pytest-benchmark,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "portion";
  version = "2.6.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AlexandreDecan";
    repo = "portion";
    tag = finalAttrs.version;
    hash = "sha256-2v93zKB9oowjklxRTkZtb1yk7XpOA0tEe6f6rQqPerY=";
  };

  build-system = [ hatchling ];

  dependencies = [ sortedcontainers ];

  pythonImportsCheck = [ "portion" ];

  nativeCheckInputs = [
    pytest-benchmark
    pytestCheckHook
  ];

  meta = {
    description = "Python library providing data structure and operations for intervals";
    homepage = "https://github.com/AlexandreDecan/portion";
    changelog = "https://github.com/AlexandreDecan/portion/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
