{ lib
, buildPythonPackage

, cmake
, ninja
, circt

, python-modules-cmake
, setuptools-scm
, numpy
, pyyaml
, pybind11
}:

buildPythonPackage rec {
  pname = "circt";
  inherit (circt) version src;

  format = "pyproject";

  nativeBuildInputs = [
    cmake
    ninja
  ];

  propagatedBuildInputs = [
    python-modules-cmake
    setuptools-scm
    numpy
    pyyaml
    pybind11
  ];

  dontUseCmakeConfigure = true;

  preConfigure = ''
    cd lib/Bindings/Python
  '';

  postPatch = ''
    substituteInPlace lib/Bindings/Python/pyproject.toml --replace "setuptools_scm==7.1.0" "setuptools_scm"
    substituteInPlace cmake/modules/GenVersionFile.cmake --replace "unknown git version" "${version}"
  '';

  pythonImportsCheck = [ "circt" ];

  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    description = "CIRCT python bindings";
    homepage = "https://github.com/llvm/circt";
    license = licenses.asl20;
    maintainers = with maintainers; [ sharzy pineapplehunter ];
  };
}
