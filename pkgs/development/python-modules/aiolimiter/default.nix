{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, importlib-metadata
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, toml
}:

buildPythonPackage rec {
  pname = "aiolimiter";
  version = "1.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mjpieters";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4wByVZoOLhrXFx9oK19GBmRcjGoJolQ3Gwx9vQV/n8s=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    toml
  ];

  patches = [
    # Switch to poetry-core, https://github.com/mjpieters/aiolimiter/pull/77
    (fetchpatch {
      name = "switch-to-peotry-core.patch";
      url = "https://github.com/mjpieters/aiolimiter/commit/84a85eff42621b0daff8fcf6bb485db313faae0b.patch";
      sha256 = "sha256-xUfJwLvMF2Xt/V1bKBFn/fjn1uyw7bGNo9RpWxtyr50=";
    })
  ];

  postPatch = ''
    substituteInPlace tox.ini \
      --replace " --cov=aiolimiter --cov-config=tox.ini --cov-report term-missing" ""
  '';

  pythonImportsCheck = [
    "aiolimiter"
  ];

  meta = with lib; {
    description = "Implementation of a rate limiter for asyncio";
    homepage = "https://github.com/mjpieters/aiolimiter";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
