{ stdenv
, buildPythonPackage
, fetchPypi
, requests
, pytest, pytestrunner, responses
}:

buildPythonPackage rec {
  pname = "matrix_client";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mgjd0ymf9mvqjkvgx3xjhxap7rzdmpa21wfy0cxbw2xcswcrqyw";
  };

  checkInputs = [ pytest pytestrunner responses ];

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "Matrix Client-Server SDK";
    homepage = "https://github.com/matrix-org/matrix-python-sdk";
    license = licenses.asl20;
    maintainers = with maintainers; [ olejorgenb ];
  };
}
