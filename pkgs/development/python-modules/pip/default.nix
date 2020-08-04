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
  version = "20.1.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = pname;
    rev = version;
    sha256 = "01wq01ysv0ijcrg8a4mj72zb8al15b8vw8g3ywhxq53kbsyhfxn4";
    name = "${pname}-${version}-source";
  };

  # Remove when solved https://github.com/NixOS/nixpkgs/issues/81441
  # Also update pkgs/development/interpreters/python/hooks/pip-install-hook.sh accordingly
  patches = [ ./reproducible.patch ];

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
