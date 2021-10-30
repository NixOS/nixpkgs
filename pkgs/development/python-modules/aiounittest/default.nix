{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, coverage
, isPy27
, wrapt
}:

buildPythonPackage rec {
  pname = "aiounittest";
  version = "1.4.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "kwarunek";
    repo = pname;
    rev = version;
    sha256 = "sha256-FixGF1JLJVqTgLaWugbeu8f+SDjpHSdSLoGklYBup4M=";
  };

  propagatedBuildInputs = [
    wrapt
  ];

  checkInputs = [
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
    maintainers = [ maintainers.costrouc ];
  };
}
