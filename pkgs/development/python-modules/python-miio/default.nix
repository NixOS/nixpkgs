{ stdenv
, buildPythonPackage
, fetchPypi
, appdirs
, click
, construct
, croniter
, cryptography
, importlib-metadata
, pytest
, pytest-mock
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

  postPatch = ''
    substituteInPlace setup.py \
      --replace  "zeroconf>=0.25.1,<0.26.0" "zeroconf"
    substituteInPlace setup.py \
      --replace  "pytz>=2019.3,<2020.0" "pytz"
    substituteInPlace setup.py \
      --replace  "cryptography>=2.9,<3.0" "cryptography"
    '';

  checkInputs = [ pytest pytest-mock];
  propagatedBuildInputs = [ appdirs click construct croniter cryptography importlib-metadata zeroconf attrs pytz tqdm netifaces ];

  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    description = "Python library for interfacing with Xiaomi smart appliances";
    homepage = "https://github.com/rytilahti/python-miio";
    license = licenses.gpl3;
    maintainers = with maintainers; [ flyfloh ];
  };
}

