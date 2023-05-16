{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pythonRelaxDepsHook
, writeText
, asttokens
, pycryptodome
<<<<<<< HEAD
, importlib-metadata
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, recommonmark
, semantic-version
, sphinx
, sphinx-rtd-theme
, pytest-runner
, setuptools-scm
, git
}:

let
  sample-contract = writeText "example.vy" ''
    count: int128

    @external
    def __init__(foo: address):
        self.count = 1
  '';

in
buildPythonPackage rec {
  pname = "vyper";
<<<<<<< HEAD
  version = "0.3.9";
=======
  version = "0.3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    sha256 = "sha256-4UBSH4qRBgsy+VO9XzosWedM65R1lTo9ml2C95T9OAA=";
=======
    sha256 = "sha256-8jw92ttKhXubzDr0tt9/OoCsPEyB9yPRsueK+j4PO6Y=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    # Git is used in setup.py to compute version information during building
    # ever since https://github.com/vyperlang/vyper/pull/2816
    git

    pythonRelaxDepsHook
    pytest-runner
    setuptools-scm
  ];

  pythonRelaxDeps = [ "asttokens" "semantic-version" ];

  propagatedBuildInputs = [
    asttokens
    pycryptodome
    semantic-version
<<<<<<< HEAD
    importlib-metadata
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    # docs
    recommonmark
    sphinx
    sphinx-rtd-theme
  ];

  checkPhase = ''
    $out/bin/vyper "${sample-contract}"
  '';

  meta = with lib; {
    description = "Pythonic Smart Contract Language for the EVM";
    homepage = "https://github.com/vyperlang/vyper";
    license = licenses.asl20;
    maintainers = with maintainers; [ siraben ];
  };
}
