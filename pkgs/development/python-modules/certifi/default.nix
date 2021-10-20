{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "certifi";
  version = "2021.05.30";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = pname;
    repo = "python-certifi";
    rev = version;
    sha256 = "1i4ljsc47iac6kl1w4w6x0qia08s9z394z9lbyzc05pm7y8a3cmj";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "certifi" ];

  meta = with lib; {
    homepage = "https://certifi.io/";
    description = "Python package for providing Mozilla's CA Bundle";
    license = licenses.isc;
    maintainers = with maintainers; [ koral ];
  };
}
