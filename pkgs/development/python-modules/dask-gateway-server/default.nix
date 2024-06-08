{
  lib,
  aiohttp,
  buildPythonPackage,
  colorlog,
  cryptography,
  fetchFromGitHub,
  go,
  pykerberos,
  pythonOlder,
  skein,
  sqlalchemy,
  traitlets,
}:

buildPythonPackage rec {
  pname = "dask-gateway-server";
  version = "2023.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dask";
    repo = "dask-gateway";
    rev = version;
    hash = "sha256-hwNLcuFN6ItH5KhC2gDUsaZT7qTC48fPR/Qx6u8B1+M=";
  };

  sourceRoot = "${src.name}/${pname}";

  nativeBuildInputs = [ go ];

  propagatedBuildInputs = [
    aiohttp
    colorlog
    cryptography
    traitlets
  ];

  passthru.optional-dependencies = {
    kerberos = [ pykerberos ];
    jobqueue = [ sqlalchemy ];
    local = [ sqlalchemy ];
    yarn = [
      skein
      sqlalchemy
    ];
  };

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  # Tests requires cluster for testing
  doCheck = false;

  pythonImportsCheck = [ "dask_gateway_server" ];

  meta = with lib; {
    description = "A multi-tenant server for securely deploying and managing multiple Dask clusters";
    homepage = "https://gateway.dask.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
