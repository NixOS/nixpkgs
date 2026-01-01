{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "pypoint";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fredrike";
    repo = "pypoint";
    tag = "v${version}";
    hash = "sha256-9z9VcY42uHIksIvDU1Vz+kvXNmrCu08fGB/waQahmyg=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "pypoint" ];

<<<<<<< HEAD
  meta = {
    description = "Python module for communicating with Minut Point";
    homepage = "https://github.com/fredrike/pypoint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
=======
  meta = with lib; {
    description = "Python module for communicating with Minut Point";
    homepage = "https://github.com/fredrike/pypoint";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
