{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  numpy,
  pytest-xdist,
  pytestCheckHook,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "pyhamcrest";
  version = "2.1.0";
<<<<<<< HEAD
  pyproject = true;
=======
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "hamcrest";
    repo = "PyHamcrest";
    tag = "V${version}";
    hash = "sha256-VkfHRo4k8g9/QYG4r79fXf1NXorVdpUKUgVrbV2ELMU=";
  };

<<<<<<< HEAD
  patches = [
    # https://github.com/hamcrest/PyHamcrest/pull/270
    ./python314-compat.patch
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

<<<<<<< HEAD
  build-system = [
=======
  nativeBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [
    numpy
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
    # Tests started failing with numpy 1.24
    "test_numpy_numeric_type_complex"
    "test_numpy_numeric_type_float"
    "test_numpy_numeric_type_int"
  ];

  pythonImportsCheck = [ "hamcrest" ];

<<<<<<< HEAD
  meta = {
    description = "Hamcrest framework for matcher objects";
    homepage = "https://github.com/hamcrest/PyHamcrest";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ alunduil ];
=======
  meta = with lib; {
    description = "Hamcrest framework for matcher objects";
    homepage = "https://github.com/hamcrest/PyHamcrest";
    license = licenses.bsd3;
    maintainers = with maintainers; [ alunduil ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
