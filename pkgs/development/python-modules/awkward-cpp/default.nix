{
  lib,
  buildPythonPackage,
  fetchPypi,
  pybind11,
  cmake,
  ninja,
  scikit-build-core,
  tomlkit,
  numpy,
}:

let
  pybind11_3 = pybind11.overridePythonAttrs (old: rec {
    version = "3.0.0";
    src = fetchPypi {
      inherit (old) pname;
      inherit version;
      hash = "sha256-w/B7zjraUcPkt2ut+oXfEWiNEsRhEfnSQrxclBWveGI=";
    };
    build-system = [
      cmake
      ninja
      scikit-build-core
    ];
    nativeCheckInputs = old.nativeCheckInputs ++ [
      tomlkit
    ];

    disabledTests = [
      # ModuleNotFoundError: No module named 'widget_module'
      "tests/test_embed/test_interpreter.py"

      # ModuleNotFoundError: No module named 'trampoline_module'
      "tests/test_embed/test_trampoline.py"
    ];

    disabledTestPaths = [
      # Hang forever
      "tests/test_multiple_interpreters.py"
    ];
  });
in
buildPythonPackage rec {
  pname = "awkward-cpp";
  version = "48";
  pyproject = true;

  src = fetchPypi {
    pname = "awkward_cpp";
    inherit version;
    hash = "sha256-NoqffTF+faQtKR9RuBTpWAgl230+twJrDUdCe/rSPi8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "pybind11>=3" "pybind11"
  '';

  build-system = [
    cmake
    ninja
    pybind11_3
    scikit-build-core
  ];

  dependencies = [ numpy ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "awkward_cpp" ];

  meta = {
    description = "CPU kernels and compiled extensions for Awkward Array";
    homepage = "https://github.com/scikit-hep/awkward";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
