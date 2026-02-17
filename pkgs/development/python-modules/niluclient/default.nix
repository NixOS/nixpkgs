{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "niluclient";
  version = "0.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11ymn0cr4lchrcnf2xxlgljw223gwln01gxwr7mcgf95yc4006iq";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "niluclient" ];

  meta = {
    description = "Python client for getting air pollution data from NILU sensor stations";
    homepage = "https://github.com/hfurubotten/niluclient";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
