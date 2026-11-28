{
  lib,
  buildPythonPackage,
  fetchPypi,
  meson-python,
  pybind11,
  metis,
  typing-extensions,
  pytestCheckHook,
  numpy,
  scipy,
}:

buildPythonPackage (finalAttrs: {
  pname = "pymetis";
  version = "2025.2.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ecbVbDDG8998x1VhfLrc/CUqF1zk5aWZgu2tDxq3HJk=";
  };

  build-system = [
    meson-python
    pybind11
  ];

  mesonFlags = [
    (lib.mesonBool "use-shipped-metis" false)
  ];

  dependencies = [
    metis
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    scipy
  ];

  pythonImportsCheck = [
    "pymetis"
  ];

  # compiled extension modules
  preCheck = ''
    rm -r pymetis
  '';

  meta = {
    description = "Python wrapper around Metis, a graph partitioning package";
    homepage = "https://documen.tician.de/pymetis/";
    downloadPage = "https://github.com/inducer/pymetis";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ stephen-huan ];
  };
})
