{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, anyio
<<<<<<< HEAD
, async-generator
=======
, async_generator
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, h11
, curio
, overly
, pytestCheckHook
, trio
}:

buildPythonPackage rec {
  pname = "asks";
  version = "3.0.0";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "theelous3";
    repo = "asks";
    rev = "v${version}";
    hash = "sha256-ipQ5n2386DqR3kNpmTVhNPG+LC7gfCbvrlZ97+UP55g=";
  };

  propagatedBuildInputs = [
    anyio
<<<<<<< HEAD
    async-generator
=======
    async_generator
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    h11
  ];

  nativeCheckInputs = [
    curio
    overly
    pytestCheckHook
    trio
  ];

  pythonImportsCheck = [ "asks" ];

  meta = {
    description = "Async requests-like HTTP library for Python";
    homepage = "https://github.com/theelous3/asks";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
