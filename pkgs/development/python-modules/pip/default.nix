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
  version = "18.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c0a292bd977ef590379a3f05d7b7f65135487b67470f6281289a94e015650ea1";
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
