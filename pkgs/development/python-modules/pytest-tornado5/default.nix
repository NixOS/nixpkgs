{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, tornado
, isPy27
}:

buildPythonPackage rec {
  pname = "pytest-tornado5";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1deadb5e27d2d44d112e0eb5d969ac9c079c75232062db57072372a3f5f366af";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ pytest tornado ];

  doCheck = !isPy27;

  meta = with stdenv.lib; {
    description = "A py.test plugin providing fixtures and markers to simplify testing of asynchronous tornado applications";
    homepage = https://github.com/vidartf/pytest-tornado;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
