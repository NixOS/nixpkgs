{
  lib,
  buildPythonPackage,
  fetchPypi,
  cmake,
  numpy,
  scikit-build,
  setuptools,
  setuptools-scm,
  wheel,
  packaging,
  pybind11,
  pydantic,
  rich,
  awkward,
  pytestCheckHook,
  scipy,
  zlib,
}:

buildPythonPackage rec {
  pname = "correctionlib";
  version = "2.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-H8QCdU6piBdqJEJOGVbsz+6eyMhFVuwTpIHKUoKaf4A=";
  };

  nativeBuildInputs = [
    cmake
    scikit-build
    setuptools
    setuptools-scm
    pybind11
  ];

  buildInputs = [ zlib ];

  propagatedBuildInputs = [
    numpy
    packaging
    pydantic
    rich
  ];

  dontUseCmakeConfigure = true;

  nativeCheckInputs = [
    awkward
    pytestCheckHook
    scipy
  ];

  pythonImportsCheck = [ "correctionlib" ];

  meta = with lib; {
    description = "Provides a well-structured JSON data format for a wide variety of ad-hoc correction factors encountered in a typical HEP analysis";
    mainProgram = "correction";
    homepage = "https://cms-nanoaod.github.io/correctionlib/";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
