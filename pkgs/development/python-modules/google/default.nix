{ lib
, fetchPypi
, buildPythonPackage
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "google";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FDUwEi7lEwUJrV6YnwUS98shiy1O3br7rUD9EOjYzL4=";
  };

  propagatedBuildInputs = [ beautifulsoup4 ];

  meta = with lib; {
    description = "Python bindings to the Google search engine";
    homepage = "http://breakingcode.wordpress.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
