{
  lib,
  buildPythonPackage,
  pytest,
  tornado,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pytest-tornado";
  version = "0.8.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cgisd7lb9q2hf55558cbn5jfhv65vsgk46ykgidzf9kqcq1kymr";
  };

  # package has no tests
  doCheck = false;

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ tornado ];

  meta = with lib; {
    description = "A py.test plugin providing fixtures and markers to simplify testing of asynchronous tornado applications.";
    homepage = "https://github.com/eugeniy/pytest-tornado";
    license = licenses.asl20;
  };
}
