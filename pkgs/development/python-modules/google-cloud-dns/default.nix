{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, google-cloud-core
, pytestCheckHook
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-dns";
  version = "0.33.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "88f009333c5e7d18cb034b4651f8c0b35e5926f732054241d5008c7cc068f7a2";
  };

  propagatedBuildInputs = [ google-api-core google-cloud-core ];

  checkInputs = [ mock pytestCheckHook ];

  preCheck = ''
    # don#t shadow python imports
    rm -r google
  '';

  disabledTests = [
    # requires credentials
    "test_quota"
  ];

  pythonImportsCheck = [ "google.cloud.dns" ];

  meta = with lib; {
    description = "Google Cloud DNS API client library";
    homepage = "https://github.com/googleapis/python-dns";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
