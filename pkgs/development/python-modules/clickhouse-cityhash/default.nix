{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "clickhouse-cityhash";
  version = "1.0.2.6";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "clickhouse_cityhash";
    hash = "sha256-Yq9sraxmVWE3cGZKsmgCjlyLcvyXgrMMD12HJK9Sx78=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "Cython>=3.0,<3.1" "Cython>=3.0"
  '';

  build-system = [
    cython
    setuptools
  ];

  doCheck = false;

  pythonImportsCheck = [ "clickhouse_cityhash" ];

  meta = {
    description = "Python-bindings for CityHash, a fast non-cryptographic hash algorithm";
    homepage = "https://github.com/xzkostyan/python-cityhash";
    changelog = "https://github.com/xzkostyan/clickhouse-cityhash/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ breakds ];
  };
})
