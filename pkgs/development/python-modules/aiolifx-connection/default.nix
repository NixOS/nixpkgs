{
  lib,
  fetchPypi,
  buildPythonPackage,
  aiolifx,
}:

buildPythonPackage rec {
  pname = "aiolifx-connection";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "aiolifx_connection";
    inherit version;
    hash = "sha256:09fydp5fqqh1s0vav39mw98i1la6qcgk17gch0m5ihyl9q50ks13";
  };

  propagatedBuildInputs = [ aiolifx ];

  # tests are not implemented
  doCheck = false;

  pythonImportsCheck = [ "aiolifx_connection" ];

  meta = {
    description = "Wrapper for aiolifx to connect to a single LIFX device";
    homepage = "https://github.com/bdraco/aiolifx_connection";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lukegb ];
  };
}
