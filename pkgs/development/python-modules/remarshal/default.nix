{ lib
, buildPythonPackage
, fetchFromGitHub

# build deps
, poetry-core

# propagates
, cbor2
, python-dateutil
, pyyaml
, tomlkit
, u-msgpack-python

# tested using
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "remarshal";
<<<<<<< HEAD
  version = "0.17.0";
=======
  version = "0.14.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dbohdan";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-FytVq9p7Yo0lS5rHj0crPIpHFjxolW8esSPkj2wLfaI=";
  };

=======
    hash = "sha256:nTM3jrPf0kGE15J+ZXBIt2+NGSW2a6VlZCKj70n5kHM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api" \
      --replace 'PyYAML = "^5.3"' 'PyYAML = "*"' \
      --replace 'tomlkit = "^0.7"' 'tomlkit = "*"'
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    cbor2
    python-dateutil
    pyyaml
    tomlkit
    u-msgpack-python
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
<<<<<<< HEAD
    changelog = "https://github.com/remarshal-project/remarshal/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Convert between TOML, YAML and JSON";
    license = licenses.mit;
    homepage = "https://github.com/dbohdan/remarshal";
    maintainers = with maintainers; [ offline ];
  };
}
