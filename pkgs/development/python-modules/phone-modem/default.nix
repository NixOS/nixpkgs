{ lib
, aioserial
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "phone-modem";
  version = "0.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "phone_modem";
    inherit version;
    hash = "sha256-7NahK9l67MdT/dDVXsq+y0Z4cZxZ/WUW2kPpE4Wz6j0=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "aioserial==1.3.0" "aioserial"
  '';

  propagatedBuildInputs = [
    aioserial
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "phone_modem" ];

  meta = with lib; {
    description = "Python module for receiving caller ID and call rejection";
    homepage = "https://github.com/tkdrob/phone_modem";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
