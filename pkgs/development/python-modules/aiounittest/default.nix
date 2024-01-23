{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonAtLeast
, setuptools
, nose
, coverage
, wrapt
}:

buildPythonPackage rec {
  pname = "aiounittest";
  version = "1.4.2";
  pyproject = true;

  # requires the imp module
  disabled = pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "kwarunek";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-7lDOI1SHPpRZLTHRTmfbKlZH18T73poJdFyVmb+HKms=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    wrapt
  ];

  nativeCheckInputs = [
    nose
    coverage
  ];

  checkPhase = ''
    nosetests
  '';

  pythonImportsCheck = [ "aiounittest" ];

  meta = with lib; {
    description = "Test asyncio code more easily";
    homepage = "https://github.com/kwarunek/aiounittest";
    license = licenses.mit;
    maintainers = [ ];
  };
}
