{
  lib,
  babelfish,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  py,
  pytest-benchmark,
  pytest-mock,
  pytestCheckHook,
  python-dateutil,
  pyyaml,
  rebulk,
}:

buildPythonPackage (finalAttrs: {
  pname = "guessit";
  version = "4.4.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "guessit";
    inherit (finalAttrs) version;
    hash = "sha256-zKLBns2HLHXufry9wRB19a6ISILsCtZ/dCw9JfLUe+s=";
  };

  build-system = [ hatchling ];

  dependencies = [
    rebulk
    babelfish
    python-dateutil
  ];

  nativeCheckInputs = [
    py
    pytestCheckHook
    pytest-mock
    pytest-benchmark
    pyyaml
  ];

  pytestFlags = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "guessit" ];

  meta = {
    description = "Python library that extracts as much information as possible from a video filename";
    homepage = "https://guessit-io.github.io/guessit/";
    changelog = "https://github.com/guessit-io/guessit/raw/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.lgpl3Only;
    maintainers = [ ];
    mainProgram = "guessit";
  };
})
