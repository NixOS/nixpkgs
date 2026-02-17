{
  lib,
  fetchPypi,
  buildPythonPackage,
  cython,
  libpq,
  uvloop,
  postgresql,
  pytest-xdist,
  pytestCheckHook,
  setuptools,
  distro,
}:

buildPythonPackage rec {
  pname = "asyncpg";
  version = "0.30.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xVHpkoq2cHYC9EgRgX+CujxEbgGL/h06vsyLpfPqyFE=";
  };

  build-system = [
    cython
    setuptools
  ];

  nativeCheckInputs = [
    libpq.pg_config
    uvloop
    postgresql
    postgresql.pg_config
    pytest-xdist
    pytestCheckHook
    distro
  ];

  # sandboxing issues on aarch64-darwin, see https://github.com/NixOS/nixpkgs/issues/198495
  doCheck = postgresql.doInstallCheck;

  preCheck = ''
    rm -rf asyncpg/

    export PGBIN=${lib.getBin postgresql}/bin
  '';

  # https://github.com/MagicStack/asyncpg/issues/1236
  disabledTests = [ "test_connect_params" ];

  pythonImportsCheck = [ "asyncpg" ];

  meta = {
    description = "Asyncio PosgtreSQL driver";
    homepage = "https://github.com/MagicStack/asyncpg";
    changelog = "https://github.com/MagicStack/asyncpg/releases/tag/v${version}";
    longDescription = ''
      Asyncpg is a database interface library designed specifically for
      PostgreSQL and Python/asyncio. asyncpg is an efficient, clean
      implementation of PostgreSQL server binary protocol for use with Python's
      asyncio framework.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eadwu ];
  };
}
