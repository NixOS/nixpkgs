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
}:

buildPythonPackage rec {
  pname = "pip";
  version = "20.0.2";
  format = "other";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = pname;
    rev = version;
    sha256 = "1jj0qa47d7pqn2r379p434hxk14ij2qgmr83x65w9ib9l8092fhg";
    name = "${pname}-${version}-source";
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
    homepage = https://pip.pypa.io/;
    priority = 10;
  };
}
