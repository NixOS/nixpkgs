{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, anyio
, async_generator
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
    async_generator
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
