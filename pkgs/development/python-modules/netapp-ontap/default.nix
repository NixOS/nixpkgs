{
  lib,
  buildPythonPackage,
  cliche,
  fetchPypi,
  marshmallow,
  pythonOlder,
  recline,
  requests,
  requests-toolbelt,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "netapp-ontap";
  version = "9.15.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "netapp_ontap";
    inherit version;
    hash = "sha256-cw8wfMKBbzN4HWLg8Xxzpnv05atKWeTZlBaBIaNWTvo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    marshmallow
    requests
    requests-toolbelt
    urllib3
    # required for cli
    cliche
    recline
  ];

  # No tests in sdist and no other download available
  doCheck = false;

  pythonImportsCheck = [ "netapp_ontap" ];

  meta = with lib; {
    description = "Library for working with ONTAP's REST APIs simply in Python";
    homepage = "https://devnet.netapp.com/restapi.php";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
    mainProgram = "ontap-cli";
  };
}
