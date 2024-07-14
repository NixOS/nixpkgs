{
  lib,
  buildPythonPackage,
  fetchPypi,
  future,
}:

buildPythonPackage rec {
  pname = "blockchain";
  version = "1.4.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-26o+67b4G0JFAFc52oAsVxsJ+Y2X62ZSCv2V2cyv6+I=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "enum-compat" ""
  '';

  propagatedBuildInputs = [ future ];

  # tests are interacting with the API and not mocking the calls
  doCheck = false;

  pythonImportsCheck = [ "blockchain" ];

  meta = with lib; {
    description = "Python client Blockchain Bitcoin Developer API";
    homepage = "https://github.com/blockchain/api-v1-client-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
