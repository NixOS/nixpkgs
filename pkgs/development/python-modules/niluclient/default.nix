{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "niluclient";
  version = "0.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11ymn0cr4lchrcnf2xxlgljw223gwln01gxwr7mcgf95yc4006iq";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "niluclient" ];

<<<<<<< HEAD
  meta = {
    description = "Python client for getting air pollution data from NILU sensor stations";
    homepage = "https://github.com/hfurubotten/niluclient";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python client for getting air pollution data from NILU sensor stations";
    homepage = "https://github.com/hfurubotten/niluclient";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
