{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "certifi";
  version = "2021.10.08";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = pname;
    repo = "python-certifi";
    rev = version;
    sha256 = "sha256-SFb/spVHK15b53ZG1P147DcTjs1dqR0+MBXzpE+CWpo=";
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
