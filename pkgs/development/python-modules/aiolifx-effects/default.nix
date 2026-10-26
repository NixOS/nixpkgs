{
  lib,
  fetchPypi,
  buildPythonPackage,
  aiolifx,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiolifx-effects";
  version = "0.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "aiolifx_effects";
    hash = "sha256-Mhxs5PNr2W9ych56WYUZTEGck4HVTQfkil3S3zHv6Qc=";
  };

  propagatedBuildInputs = [ aiolifx ];

  # tests are not implemented
  doCheck = false;

  pythonImportsCheck = [ "aiolifx_effects" ];

  meta = {
    changelog = "https://github.com/amelchio/aiolifx_effects/releases/tag/v${finalAttrs.version}";
    description = "Light effects (pulse, colorloop ...) for LIFX lights running on aiolifx";
    homepage = "https://github.com/amelchio/aiolifx_effects";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ netixx ];
  };
})
