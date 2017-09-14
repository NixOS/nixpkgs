{ lib
, buildPythonPackage
, fetchPypi
, ntlm-auth
, requests
}:

buildPythonPackage rec {
  pname = "requests_ntlm";
  version = "1.0.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hb689p2jyb867c2wlq5mjkqxgc0jq6lxv3rmhw8rq9qangk3jjk";
  };

  propagatedBuildInputs = [ ntlm-auth requests ];

  # Tests require networking
  doCheck = false;

  meta = with lib; {
    description = "HTTP NTLM authentication support for python-requests";
    homepage = https://github.com/requests/requests-ntlm;
    license = licenses.isc;
    maintainers = with maintainers; [ elasticdog ];
    platforms = platforms.all;
  };
}
