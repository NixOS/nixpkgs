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
, croniter
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "python-miio";
  version = "0.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3be5275b569844dfa267c80a1e23dc0957411dd501cae0ed3cccf43467031ceb";
  };

  # use any available version from nixpkgs
  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytz>=2019.3,<2020.0" "pytz" \
      --replace "cryptography>=2.9,<3.0" "cryptography" \
      --replace "zeroconf>=0.25.1,<0.26.0" "zeroconf"
  '';

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ appdirs click construct cryptography zeroconf attrs pytz tqdm netifaces croniter ]
    ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  # tests/test_device.py appears to be broken
  checkPhase = ''
    rm miio/tests/test_device.py
    pytest
  '';

  meta = with stdenv.lib; {
    description = "Python library for interfacing with Xiaomi smart appliances";
    homepage = "https://github.com/rytilahti/python-miio";
    license = licenses.gpl3;
    maintainers = with maintainers; [ flyfloh ];
  };
}
