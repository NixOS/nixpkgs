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
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8d23caf4906f2112dc88b9a6d5e1767877744cae016cd71c2bf75592a4be3b79";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ appdirs click construct cryptography zeroconf attrs pytz tqdm netifaces ];

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

