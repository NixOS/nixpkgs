{ lib
, buildPythonPackage
, fetchPypi
, ntlm-auth
, requests
}:

buildPythonPackage rec {
  pname = "requests_ntlm";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-M8KF9QdOMXy90zjRma+kanwBEy5cER02vUFVNOm5Fqg=";
  };

  propagatedBuildInputs = [ ntlm-auth requests ];

  # Tests require networking
  doCheck = false;

  meta = with lib; {
    description = "HTTP NTLM authentication support for python-requests";
    homepage = "https://github.com/requests/requests-ntlm";
    license = licenses.isc;
    maintainers = with maintainers; [ elasticdog ];
    platforms = platforms.all;
  };
}
