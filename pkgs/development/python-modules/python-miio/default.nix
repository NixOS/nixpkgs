{ stdenv
, buildPythonPackage
, fetchPypi
, appdirs
, click
, construct
, cryptography
, pytest
, zeroconf
, attrs
, pytz
, tqdm
, netifaces
}:

buildPythonPackage rec {
  pname = "python-miio";
  version = "0.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3be5275b569844dfa267c80a1e23dc0957411dd501cae0ed3cccf43467031ceb";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ appdirs click construct cryptography zeroconf attrs pytz tqdm netifaces ];

  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    broken = true;
    description = "Python library for interfacing with Xiaomi smart appliances";
    homepage = "https://github.com/rytilahti/python-miio";
    license = licenses.gpl3;
    maintainers = with maintainers; [ flyfloh ];
  };
}

