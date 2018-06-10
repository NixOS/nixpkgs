{ lib
, buildPythonPackage
, fetchPypi
, ntlm-auth
, requests
}:

buildPythonPackage rec {
  pname = "requests_ntlm";
  version = "1.1.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9189c92e8c61ae91402a64b972c4802b2457ce6a799d658256ebf084d5c7eb71";
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
