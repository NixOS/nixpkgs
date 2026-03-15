{
  lib,
  fetchPypi,
  buildPythonPackage,
  pbr,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hbreader";
  version = "0.9.1";
  format = "setuptools";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0sEy+LpidteUxmIkwyl87CXIB50KTPAZwGFhHgo7lPo=";
  };

  build-system = [
    setuptools
    pbr
  ];

  pythonImportsCheck = [ "hbreader" ];

  meta = {
    description = "Generic file, URL, and string reader";
    homepage = "https://github.com/hsolbrig/hbreader";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
