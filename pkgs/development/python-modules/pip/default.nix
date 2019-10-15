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
}:

buildPythonPackage rec {
  pname = "pip";
  version = "19.2.3";
  format = "other";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e7a31f147974362e6c82d84b91c7f2bdf57e4d3163d3d454e6c3e71944d67135";
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
    license = lib.licenses.mit;
    homepage = https://pip.pypa.io/;
    priority = 10;
  };
}
