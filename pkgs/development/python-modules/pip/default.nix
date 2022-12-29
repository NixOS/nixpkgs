{ lib
, buildPythonPackage
, bootstrapped-pip
, fetchFromGitHub
, mock
, scripttest
, virtualenv
, pretend
, pytest

# coupled downsteam dependencies
, pip-tools
}:

buildPythonPackage rec {
  pname = "pip";
  version = "22.3.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-mrfd3VWqb4SgSjBJAxBhYegABdJa7pVXL7wA5uZtF/A=";
    name = "${pname}-${version}-source";
  };

  nativeBuildInputs = [ bootstrapped-pip ];

  postPatch = ''
    # Remove vendored Windows PE binaries
    # Note: These are unused but make the package unreproducible.
    find -type f -name '*.exe' -delete
  '';

  # pip detects that we already have bootstrapped_pip "installed", so we need
  # to force it a little.
  pipInstallFlags = [ "--ignore-installed" ];

  checkInputs = [ mock scripttest virtualenv pretend pytest ];
  # Pip wants pytest, but tests are not distributed
  doCheck = false;

  passthru.tests = { inherit pip-tools; };

  meta = {
    description = "The PyPA recommended tool for installing Python packages";
    license = with lib.licenses; [ mit ];
    homepage = "https://pip.pypa.io/";
    priority = 10;
  };
}
