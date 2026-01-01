{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,

  # passthru tests
  apache-beam,
  datasets,
}:

buildPythonPackage rec {
  pname = "dill";
<<<<<<< HEAD
  version = "0.4.0-unstable-2025-11-09";
  pyproject = true;
=======
  version = "0.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "uqfoundation";
    repo = "dill";
<<<<<<< HEAD
    rev = "d948ecd748772f2812361982ec1496da0cd47b53";
    hash = "sha256-/A84BpZnwSwsEYqLL0Xdf8OjJtg1UMu6dig3QEN+n1A=";
=======
    tag = version;
    hash = "sha256-RIyWTeIkK5cS4Fh3TK48XLa/EU9Iwlvcml0CTs5+Uh8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ setuptools ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} dill/tests/__main__.py
    runHook postCheck
  '';

  passthru.tests = {
    inherit apache-beam datasets;
  };

  pythonImportsCheck = [ "dill" ];

<<<<<<< HEAD
  meta = {
    description = "Serialize all of python (almost)";
    homepage = "https://github.com/uqfoundation/dill/";
    changelog = "https://github.com/uqfoundation/dill/releases/tag/dill-${version}";
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "Serialize all of python (almost)";
    homepage = "https://github.com/uqfoundation/dill/";
    changelog = "https://github.com/uqfoundation/dill/releases/tag/dill-${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tjni ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
