{
  lib,
  fetchPypi,
  buildPythonPackage,
  hatchling,
  jsonasobj,
  requests,
  uv-dynamic-versioning,
}:

buildPythonPackage rec {
  pname = "pyjsg";
  version = "0.12.5";
  pyproject = true;
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d5bN4M4ivyRZ9WAcGi4s/cungoVYZ+ixhTZOS+lkrms=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  propagatedBuildInputs = [
    jsonasobj
    requests
  ];

  pythonImportsCheck = [ "pyjsg" ];

  meta = {
    description = "Python implementation of JSON Schema Grammar";
    homepage = "https://github.com/hsolbrig/pyjsg";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
