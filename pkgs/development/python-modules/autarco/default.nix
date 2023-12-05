{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "autarco";
  version = "0.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-autarco";
    rev = "v${version}";
    hash = "sha256-3f6N4b6WZPAUUQTuGeb20q0f7ZqDR+O24QRze5RpRlw=";
  };

  patches = [
    # https://github.com/klaasnicolaas/python-autarco/pull/265
    (fetchpatch {
      name = "remove-setuptools-dependency.patch";
      url = "https://github.com/klaasnicolaas/python-autarco/commit/bf40e8a4f64cd9c9cf72930260895537ea5b2adc.patch";
      hash = "sha256-Fgijy7sd67LUIqh3qjQjyothnjdW7Zcil/bQSuVsBR8=";
    })
  ];

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${version}" \
      --replace "--cov" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "autarco"
  ];

  meta = with lib; {
    description = "Module for the Autarco Inverter";
    homepage = "https://github.com/klaasnicolaas/python-autarco";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
