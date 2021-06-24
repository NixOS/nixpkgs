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
  version = "0.32.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ec98a9933b2abd95b174c9cae0477b90aa4c1f5068b69a9f8ced6d20db1cd5a";
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
