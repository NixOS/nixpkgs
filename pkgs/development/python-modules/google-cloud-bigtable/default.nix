{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, google-cloud-core
, grpc-google-iam-v1
, libcst
, mock
, proto-plus
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "google-cloud-bigtable";
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-R7HGbURhqOxPXUlKN3+mk5+qP6Em5HmxBAa7LHsjJJk=";
  };

  propagatedBuildInputs = [
    google-api-core
    google-cloud-core
    grpc-google-iam-v1
    libcst
    proto-plus
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  checkPhase = ''
    # Prevent google directory from shadowing google imports
    rm -r google
  '';

  disabledTests = [
    "policy"
  ];

  pythonImportsCheck = [
    "google.cloud.bigtable_admin_v2"
    "google.cloud.bigtable_v2"
    "google.cloud.bigtable"
  ];

  meta = with lib; {
    description = "Google Cloud Bigtable API client library";
    homepage = "https://github.com/googleapis/python-bigtable";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
