{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  pytestCheckHook,
  plover,
}:

buildPythonPackage (finalAttrs: {
  pname = "plover-python-dictionary";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "opensteno";
    repo = "plover_python_dictionary";
    tag = finalAttrs.version;
    hash = "sha256-4li8WjriJdeLbu+JANuVOb9ejBGusHBm+AaLxyy91A0=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    plover
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "plover_python_dictionary"
  ];

  meta = {
    description = "Python dictionaries support for Plover";
    homepage = "https://github.com/opensteno/plover_python_dictionary";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      pandapip1
      ShamrockLee
    ];
  };
})
