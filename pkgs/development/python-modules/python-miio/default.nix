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
  version = "0.5.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fa9c318256945ad4a8623fdf921ce81c466a7aea18b04a6711efb662f520b195";
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

