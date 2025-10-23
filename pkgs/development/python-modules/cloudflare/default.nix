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
  version = "4.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-seHGvuuNmPY7/gocuodPxOIuAAvMSQVE+VbGibO1slg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'hatchling==1.26.3' 'hatchling>=1.26.3'
  '';

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
    changelog = "https://github.com/cloudflare/cloudflare-python/blob/v${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      marie
      jemand771
    ];
    license = lib.licenses.asl20;
  };
}
