{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  execnet,
}:

buildPythonPackage rec {
  pname = "pytest-cache";
  version = "1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a873fihw4rhshc722j4h6j7g3nj7xpgsna9hhg3zn6ksknnhx5y";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ execnet ];

  checkPhase = ''
    py.test
  '';

  # Too many failing tests. Are they maintained?
  doCheck = false;

<<<<<<< HEAD
  meta = {
    license = lib.licenses.mit;
=======
  meta = with lib; {
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://pypi.python.org/pypi/pytest-cache/";
    description = "Pytest plugin with mechanisms for caching across test runs";
  };
}
