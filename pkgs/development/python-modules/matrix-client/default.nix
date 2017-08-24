{ stdenv
, buildPythonPackage
, fetchPypi
, pythonPackages
}:

buildPythonPackage rec {
  pname = "matrix-client";
  version = "0.0.6";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15kx5px26hwr0sxpyjk4w61fjnabg1b57hwys1nyarc0jx4qjhiq";
  };

  checkInputs = with pythonPackages; [ tox pytest flake8 responses ];

  propagatedBuildInputs = with pythonPackages; [ requests ];

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
