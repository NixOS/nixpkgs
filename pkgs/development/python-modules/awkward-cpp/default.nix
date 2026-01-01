{
  lib,
  buildPythonPackage,
  fetchPypi,
  cmake,
  ninja,
  pybind11,
  scikit-build-core,
  numpy,
}:

buildPythonPackage rec {
  pname = "awkward-cpp";
<<<<<<< HEAD
  version = "51";
=======
  version = "50";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    pname = "awkward_cpp";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-jHTo+fslAXZtGw+fLrh3fjhEEdM1NKj6Zn1WWZIjoEs=";
=======
    hash = "sha256-JktvtOgqzBBXtbL/DTP6vDYQMlKOIzgVzSIkxtvJbY4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    cmake
    ninja
    pybind11
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
