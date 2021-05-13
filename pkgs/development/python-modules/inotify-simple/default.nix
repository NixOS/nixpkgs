{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "inotify-simple";
  version = "1.3.5";

  src = fetchPypi {
    pname = "inotify_simple";
    inherit version;
    sha256 = "hED/5JxK6BqN9Xwa4etLa/p6y4MAmb+z4wWzgwBcwSg=";
  };

  # The package has no tests
  doCheck = false;

  meta = with lib; {
    description = "A simple Python wrapper around inotify";
    homepage = "https://github.com/chrisjbillington/inotify_simple";
    license = licenses.bsd2;
    maintainers = with maintainers; [ earvstedt ];
  };
}
