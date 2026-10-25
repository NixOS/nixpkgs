{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  pymysql,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiomysql";
  version = "0.3.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiomysql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DBNLmroR1W/gsYtW0iGNpki6EYUq6MyHI2pCRdyapU4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        "setuptools_scm[toml] >= 7, < 10" \
        "setuptools_scm[toml]"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ pymysql ];

  # Tests require MySQL database
  doCheck = false;

  pythonImportsCheck = [ "aiomysql" ];

  meta = {
    description = "MySQL driver for asyncio";
    homepage = "https://github.com/aio-libs/aiomysql";
    changelog = "https://github.com/aio-libs/aiomysql/blob/${finalAttrs.src.rev}/CHANGES.txt";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
