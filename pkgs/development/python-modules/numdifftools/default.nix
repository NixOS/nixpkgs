{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
<<<<<<< HEAD
  scipy,
  pdm-backend,
=======
  pythonOlder,
  scipy,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "numdifftools";
<<<<<<< HEAD
  version = "0.9.42";
  pyproject = true;
=======
  version = "0.9.41";
  format = "setuptools";

  disabled = pythonOlder "3.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "pbrod";
    repo = "numdifftools";
<<<<<<< HEAD
    tag = "v${version}";
    hash = "sha256-tNPv+KJuSmMHItHfRUjMIFtAFB+vC530sp+Am0VRG44=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
=======
    rev = "v${version}";
    hash = "sha256-HYacLaowSDdrwkxL1h3h+lw/8ahzaecpXEnwrCqMCWk=";
  };

  propagatedBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    numpy
    scipy
  ];

  # Tests requires algopy and other modules which are optional and/or not available
  doCheck = false;

<<<<<<< HEAD
  pythonImportsCheck = [ "numdifftools" ];

  meta = {
    description = "Library to solve automatic numerical differentiation problems in one or more variables";
    homepage = "https://github.com/pbrod/numdifftools";
    changelog = "https://github.com/pbrod/numdifftools/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
=======
  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
    # Remove optional dependencies
    substituteInPlace requirements.txt \
      --replace "algopy>=0.4" "" \
      --replace "statsmodels>=0.6" ""
  '';

  pythonImportsCheck = [ "numdifftools" ];

  meta = with lib; {
    description = "Library to solve automatic numerical differentiation problems in one or more variables";
    homepage = "https://github.com/pbrod/numdifftools";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
