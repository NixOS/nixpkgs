{ stdenv
, buildPythonPackage
, fetchPypi
, enum34
, grpc_google_iam_v1
, google_api_core
, pytest
}:

buildPythonPackage rec {
  pname = "google-cloud-asset";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cec2f44a670371e24e6140c454fdac3ed06be0a021042c6756a3284b505335c7";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ enum34 grpc_google_iam_v1 google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Cloud Asset API API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
