{
  lib,
  buildPythonPackage,
  fetchPypi,
  httpx,
  pydantic,
  typing-extensions,
  anyio,
  distro,
  sniffio,
  pythonOlder,
  hatchling,
  hatch-fancy-pypi-readme,
}:

buildPythonPackage rec {
  pname = "cloudflare";
  version = "4.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-a5++mUhW/pQq3GpIgbe+3tIIA03FxT3Wg3UfYy5Hoaw=";
  };

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
  ];

  dependencies = [
    httpx
    pydantic
    typing-extensions
    anyio
    distro
    sniffio
  ];

  # tests require networking
  doCheck = false;

  pythonImportsCheck = [ "cloudflare" ];

  meta = {
    description = "Official Python library for the Cloudflare API";
    homepage = "https://github.com/cloudflare/cloudflare-python";
    changelog = "https://github.com/cloudflare/cloudflare-python/blob/${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      marie
      jemand771
    ];
    license = lib.licenses.asl20;
  };
}
