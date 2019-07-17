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
  version = "19.1.1";
  format = "other";

  src = fetchPypi {
    inherit pname version;
    sha256 = "44d3d7d3d30a1eb65c7e5ff1173cdf8f7467850605ac7cc3707b6064bddd0958";
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
