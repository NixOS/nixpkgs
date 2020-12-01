{ lib
, python
, buildPythonPackage
, bootstrapped-pip
, fetchPypi
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
  version = "20.3";
  format = "other";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03kfx8ymqllv5lyngnylqks6h3z04ky29l29kcm2vhpaarkcmrws";
  };

  nativeBuildInputs = [ bootstrapped-pip ];

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
