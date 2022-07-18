{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
, pythonOlder
, scipy
}:

buildPythonPackage rec {
  pname = "numdifftools";
  version = "0.9.40";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pbrod";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YLi9cNHcZ/PlhrhvYOMfRTOt4kinQcfxvqInT8/0Qpg=";
  };

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  # Tests requires algopy and other modules which are optional and/or not available
  doCheck = false;

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
    # Remove optional dependencies
    substituteInPlace requirements.txt \
      --replace "algopy>=0.4" "" \
      --replace "statsmodels>=0.6" ""
  '';

  pythonImportsCheck = [
    "numdifftools"
  ];

  meta = with lib; {
    description = "Library to solve automatic numerical differentiation problems in one or more variables";
    homepage = "https://github.com/pbrod/numdifftools";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
