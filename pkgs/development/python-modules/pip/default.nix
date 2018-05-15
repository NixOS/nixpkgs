{ lib
, buildPythonPackage
, fetchPypi
, mock
, scripttest
, virtualenv
, pretend
, pytest
}:

buildPythonPackage rec {
  pname = "pip";
  version = "10.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f2bd08e0cd1b06e10218feaf6fef299f473ba706582eb3bd9d52203fdbd7ee68";
  };

  # pip detects that we already have bootstrapped_pip "installed", so we need
  # to force it a little.
  installFlags = [ "--ignore-installed" ];

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
