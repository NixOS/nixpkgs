{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  poetry-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "nvsmi";
  version = "0.4.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-waORx8Ta3G7FcpCf8DckUdRk663BROWqX7vMiT3Le/o=";
  };

  # Packaged before poetry split its build backend out into poetry-core, so the declared backend no
  # longer exists. Unmaintained since 2020, so this will not be fixed upstream.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry.masonry.api" "poetry.core.masonry.api" \
      --replace-fail 'poetry>=0.12' 'poetry-core'
  '';

  build-system = [ poetry-core ];

  # The test suite needs an NVIDIA GPU and a working nvidia-smi.
  doCheck = false;

  pythonImportsCheck = [ "nvsmi" ];

  meta = {
    description = "Friendly wrapper to nvidia-smi";
    homepage = "https://github.com/pmav99/nvsmi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ giggio ];
    platforms = lib.platforms.linux;
  };
})
