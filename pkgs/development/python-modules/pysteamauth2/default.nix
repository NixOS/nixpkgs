{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  aiohttp,
  bitstring,
  protobuf,
  pydantic,
  rsa,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysteamauth2";
  version = "1.1.9";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-0MDKRAeVJSHy/VjlOk2RwOT4eb8JBkolVSqiZkwOOZ8=";
  };

  # relax dependency versions
  postPatch = ''
    sed -i -E 's/==[0-9\.]+//g' setup.py
  '';

  pyproject = true;
  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    bitstring
    protobuf
    pydantic
    rsa
    urllib3
  ];

  pythonImportsCheck = [ "pysteamauth" ];

  meta = {
    description = "Asynchronous python library for Steam authorization using protobuf";
    homepage = "https://github.com/AdiEcho/pysteamauth";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ulysseszhan ];
  };
})
