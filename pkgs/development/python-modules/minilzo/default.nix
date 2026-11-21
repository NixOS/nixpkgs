{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage rec {
  pname = "minilzo";
  version = "1.2";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TNzA3D6FWKKdim/tXGahrjyAFOEtCidVSJDEJI92sUE=";
  };

  build-system = [ setuptools ];

  meta = {
    description = "Library to deal with lzo files compressed with lzop";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.fidgetingbits ];
  };
}
