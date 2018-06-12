{ stdenv
, buildPythonPackage
, fetchPypi
, requests
, tox, pytest, flake8, responses
}:

buildPythonPackage rec {
  pname = "matrix-client";
  version = "0.2.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b96e87adf1bc2270166b2a4cff1320d2ef283779ea8b3c4edd0d9051fc7b7924";
  };

  checkInputs = [ tox pytest flake8 responses ];

  propagatedBuildInputs = [ requests ];

  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    description = "Matrix Client-Server SDK";
    homepage = https://github.com/matrix-org/matrix-python-sdk;
    license = licenses.asl20;
    maintainers = with maintainers; [ olejorgenb ];
  };
}
