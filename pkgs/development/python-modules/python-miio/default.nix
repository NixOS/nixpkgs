{ lib
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
  version = "0.5.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dc804e6ebcad927eab2d44fec0c970ceb7aa43801f0a0c62313266d88c26fb91";
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

  meta = with lib; {
    description = "Python library for interfacing with Xiaomi smart appliances";
    homepage = "https://github.com/rytilahti/python-miio";
    license = licenses.gpl3;
    maintainers = with maintainers; [ flyfloh ];
  };
}

