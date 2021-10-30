{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyrfxtrx";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyRFXtrx";
    rev = version;
    sha256 = "0nzgy56b2v3bnn9idlb67qkzj4cj5j9v1436ri1y305fqwjy48nm";
  };

  propagatedBuildInputs = [
    pyserial
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Library to communicate with the RFXtrx family of devices";
    homepage = "https://github.com/Danielhiversen/pyRFXtrx";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
