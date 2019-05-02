{ lib
, buildPythonPackage
, pytest
, tornado
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pytest-tornado";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ndwjsad901km7zw8xxj3igjff651hg1pjcmv5vqx458xhnmbfqw";
  };

  # package has no tests
  doCheck = false;

  propagatedBuildInputs = [ pytest tornado ];

  meta = with lib; {
    description = "A py.test plugin providing fixtures and markers to simplify testing of asynchronous tornado applications.";
    homepage =  https://github.com/eugeniy/pytest-tornado;
    license = licenses.asl20;
    maintainers = with maintainers; [ ixxie ];
  };
}
