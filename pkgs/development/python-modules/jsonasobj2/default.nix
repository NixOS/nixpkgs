{
  lib,
  fetchPypi,
  buildPythonPackage,
  hbreader,
  pbr,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "jsonasobj2";
  version = "1.0.4";
  pyproject = true;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9QsWaO9HgASqSHstLQlMME5ctreTN4CfSh8pdcx/u04=";
  };

  build-system = [
    setuptools
    pbr
    wheel
  ];
  propagatedBuildInputs = [ hbreader ];

  pythonImportsCheck = [ "jsonasobj2" ];

  meta = {
    description = "Treat JSON name/value pairs as Python object attributes";
    homepage = "https://github.com/hsolbrig/jsonasobj2";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
