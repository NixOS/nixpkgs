{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "nvsmi";
  version = "0.4.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pmav99";
    repo = "nvsmi";
    tag = finalAttrs.version;
    hash = "sha256-oyvkxW9dNxc3Izko88BcVSDQJcpafN6qoxuPt69n5Cg=";
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
