{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pymysql,
  setuptools,
  setuptools-scm,
  wheel,
}:

buildPythonPackage rec {
  pname = "aiomysql";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiomysql";
    tag = "v${version}";
    hash = "sha256-DBNLmroR1W/gsYtW0iGNpki6EYUq6MyHI2pCRdyapU4=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [ pymysql ];

  # Tests require MySQL database
  doCheck = false;

  pythonImportsCheck = [ "aiomysql" ];

  meta = {
    description = "MySQL driver for asyncio";
    homepage = "https://github.com/aio-libs/aiomysql";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
