{ lib
, python
, buildPythonPackage
, bootstrapped-pip
, fetchFromGitHub
, mock
, scripttest
, virtualenv
, pretend
, pytest
, setuptools
, wheel
, isPy27
, fetchpatch
}:

buildPythonPackage rec {
  pname = "pip";
  version = "20.2.4";
  format = "other";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = pname;
    rev = version;
    sha256 = "eMVV4ftgV71HLQsSeaOchYlfaJVgzNrwUynn3SA1/Do=";
    name = "${pname}-${version}-source";
  };

  nativeBuildInputs = [ bootstrapped-pip ];

  patches = lib.optionals isPy27 [
    (fetchpatch {
      url = "https://github.com/pypa/pip/commit/94fbb6cf78c267bf7cdf83eeeb2536ad56cfe639.patch";
      sha256 = "Z6x5yxBp8QkU/GOfb1ltI0dVt//MaI09XK3cdY42kFs=";
    })
  ];

  # pip detects that we already have bootstrapped_pip "installed", so we need
  # to force it a little.
  pipInstallFlags = [ "--ignore-installed" ];

  checkInputs = [ mock scripttest virtualenv pretend pytest ];
  # Pip wants pytest, but tests are not distributed
  doCheck = false;

  meta = {
    description = "The PyPA recommended tool for installing Python packages";
    license = with lib.licenses; [ mit ];
    homepage = "https://pip.pypa.io/";
    priority = 10;
  };
}
