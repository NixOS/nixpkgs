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
  version = "19.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n09vnyn8q3vf31prb050s2nfx4gvwy1gwazgrfbc7hasg9xgls4";
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
