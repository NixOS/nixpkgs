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
  version = "4.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eLEiLVMghLspq3ACV2F/r9gCokxa+bBW83m5lOkpr34=";
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
