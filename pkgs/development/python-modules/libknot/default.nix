{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # native dependencies
  knot-dns,
}:

buildPythonPackage rec {
  pname = "libknot";
  version = "3.5.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jnJ7xWO29V04Xln8xSZ+ky5ravQ2rEpSRx8Xh6PWbyw=";
  };

  postPatch = ''
    substituteInPlace libknot/__init__.py \
      --replace "libknot%s.dylib" "${lib.getLib knot-dns}/lib/libknot%s.dylib" \
      --replace "libknot.so%s" "${lib.getLib knot-dns}/lib/libknot.so%s"
  '';

  build-system = [ hatchling ];

  pythonImportsCheck = [ "libknot" ];

  meta = {
    description = "Python bindings for libknot";
    homepage = "https://gitlab.nic.cz/knot/knot-dns/-/tree/master/python/libknot";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
