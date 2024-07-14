{
  lib,
  buildPythonPackage,
  fetchPypi,
  robotframework-seleniumlibrary,
}:

buildPythonPackage rec {
  version = "3.0.0";
  format = "setuptools";
  pname = "robotframework-selenium2library";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ko6UKweIsW3tJTA5AIs00rRhmSg0YbKU8PQaV5xw/ac=";
  };

  # Neither the PyPI tarball nor the repository has tests
  doCheck = false;

  propagatedBuildInputs = [ robotframework-seleniumlibrary ];

  meta = with lib; {
    description = "Web testing library for Robot Framework";
    homepage = "https://github.com/robotframework/Selenium2Library";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
