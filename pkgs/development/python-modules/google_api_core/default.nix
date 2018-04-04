{ stdenv, buildPythonPackage, fetchPypi
, google_auth, protobuf3_5, googleapis_common_protos, requests, grpcio, setuptools, mock, pytest }:

buildPythonPackage rec {
  pname = "google-api-core";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b4f103de6bd38ab346f7d17236f6098a51ebdff733ff69956a0f1e29cb35f10b";
  };

  propagatedBuildInputs = [ google_auth protobuf3_5 googleapis_common_protos requests grpcio ];
  checkInputs = [ setuptools mock pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "This library is not meant to stand-alone. Instead it defines common helpers used by all Google API clients.";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ vanschelven ];
  };
}
