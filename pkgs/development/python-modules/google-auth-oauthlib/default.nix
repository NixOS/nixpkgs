{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, click
, mock
, pytest
, futures
, google_auth
, requests_oauthlib
}:

buildPythonPackage rec {
  pname = "google-auth-oauthlib";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "65b65bc39ad8cab15039b35e5898455d3d66296d0584d96fe0e79d67d04c51d9";
  };

  checkInputs = [
    click mock pytest
  ] ++ lib.optionals (!isPy3k) [ futures ];

  propagatedBuildInputs = [
    google_auth requests_oauthlib
  ];

  doCheck = isPy3k;
  checkPhase = ''
    rm -fr tests/__pycache__/ google
    py.test
  '';

  meta = with lib; {
    description = "Google Authentication Library: oauthlib integration";
    homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python-oauthlib";
    license = licenses.asl20;
    maintainers = with maintainers; [ terlar ];
  };
}
