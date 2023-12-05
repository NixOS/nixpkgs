{ lib
, buildPythonPackage
, fetchPypi
, cliche
, marshmallow
, pytestCheckHook
, recline
, requests
, requests-toolbelt
, urllib3
}:

buildPythonPackage rec {
  pname = "netapp-ontap";
  version = "9.14.1.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "netapp_ontap";
    inherit version;
    sha256 = "sha256-nh7SHcyujTVXSgxQajRA4EueN6Hf8cKueQbsbnr6+qw=";
  };

  propagatedBuildInputs = [
    marshmallow
    requests
    requests-toolbelt
    urllib3
    # required for cli
    cliche
    recline
  ];

  # no tests in sdist and no other download available
  doCheck = false;

  pythonImportsCheck = [ "netapp_ontap" ];

  meta = with lib; {
    description = "A library for working with ONTAP's REST APIs simply in Python";
    homepage = "https://devnet.netapp.com/restapi.php";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
