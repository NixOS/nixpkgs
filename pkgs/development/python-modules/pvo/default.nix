{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pydantic
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "pvo";
  version = "0.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-pvoutput";
    rev = "v${version}";
    sha256 = "sha256-IXK4DvmwSLdxyW4418pe1/UOeQELUBSnTO+P6TzPnKw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    pydantic
    yarl
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${version}" \
      --replace "--cov" ""
  '';

  pythonImportsCheck = [
    "pvo"
  ];

  meta = with lib; {
    description = "Python module to interact with the PVOutput API";
    homepage = "https://github.com/frenck/python-pvoutput";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
