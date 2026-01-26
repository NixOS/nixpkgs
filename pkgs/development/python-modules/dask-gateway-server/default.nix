{
  lib,
  aiohttp,
  buildPythonPackage,
  colorlog,
  cryptography,
  fetchFromGitHub,
  go,
  pykerberos,
  skein,
  sqlalchemy,
  traitlets,
}:

buildPythonPackage rec {
  pname = "dask-gateway-server";
  version = "2023.9.0";
  format = "setuptools";

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

  optional-dependencies = {
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

  meta = {
    description = "Multi-tenant server for securely deploying and managing multiple Dask clusters";
    homepage = "https://gateway.dask.org/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
