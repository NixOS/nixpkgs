{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  ciso8601,
  leb128,
  lz4,
  pytz,
  tzlocal,
  zstd,
  clickhouse-cityhash,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "asynch";
  version = "0.3.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-2Ls8F5OnSi6dRMx+hAbq0884GMEezW2EBbcCsjFIxYQ=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    ciso8601
    leb128
    lz4
    pytz
    tzlocal
    zstd
  ];

  pythonRelaxDeps = [ "pytz" ];

  optional-dependencies = {
    compression = [
      clickhouse-cityhash
    ];
  };

  pythonImportsCheck = [
    "asynch"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "An asyncio driver for ClickHouse with native TCP support";
    homepage = "https://pypi.org/project/asynch";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
