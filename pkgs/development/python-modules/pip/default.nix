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
  version = "23.0.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-BSonlwKmegrlrQTTIL0avPi61/TY2M0f7kOZpSzPRQk=";
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

  nativeCheckInputs = [ mock scripttest virtualenv pretend pytest ];
  # Pip wants pytest, but tests are not distributed
  doCheck = false;

  passthru.tests = { inherit pip-tools; };

  meta = {
    description = "The PyPA recommended tool for installing Python packages";
    license = with lib.licenses; [ mit ];
    homepage = "https://pip.pypa.io/";
    changelog = "https://pip.pypa.io/en/stable/news/#v${lib.replaceStrings [ "." ] [ "-" ] version}";
    priority = 10;
  };
}
