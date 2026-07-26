{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pulsectl,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pulsectl-asyncio";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mhthies";
    repo = "pulsectl-asyncio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SbNDX5tcNSfifT1Bpv5haKrPtkupH+bwM8Yc4jNbnz8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "pulsectl >=23.5.0,<=24.12.0" "pulsectl >=23.5.0"
  '';

  build-system = [ setuptools ];

  dependencies = [ pulsectl ];

  # Tests require a running pulseaudio instance
  doCheck = false;

  pythonImportsCheck = [ "pulsectl_asyncio" ];

  meta = {
    description = "Python bindings library for PulseAudio";
    homepage = "https://github.com/mhthies/pulsectl-asyncio";
    changelog = "https://github.com/mhthies/pulsectl-asyncio/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
