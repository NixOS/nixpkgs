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
  version = "19.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f851133f8b58283fa50d8c78675eb88d4ff4cde29b6c41205cd938b06338e0e5";
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
