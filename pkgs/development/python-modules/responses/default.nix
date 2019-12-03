{ buildPythonPackage
, fetchPypi
, lib
, cookies
, mock
, requests
, six
, flake8
, pytest
, pytestcov
, pytest-localserver
}:

buildPythonPackage rec {
  pname = "responses";
  version = "0.10.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fv28b89bhpba3kyfhay8284dw0yapafs178qxmi1ilzl53fbm26";
  };

  nativeBuildInputs = [ flake8 pytest pytestcov pytest-localserver ];
  propagatedBuildInputs = [ cookies mock requests six ];

  meta = with lib; {
    description = "A utility library for mocking out the requests Python library";
    homepage = "https://github.com/getsentry/responses";
    license = licenses.apsl20;
    maintainers = with maintainers; [ mtrsk ];
    platforms = platforms.linux;
  };
}
