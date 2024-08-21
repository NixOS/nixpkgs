{
  lib,
  buildPythonPackage,
  fetchPypi,
  inotify-simple,
}:

buildPythonPackage rec {
  pname = "inotifyrecursive";
  version = "0.3.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "osRQsxdpPkU4QW+Q6x14WFBtr+a4uIUDe9LdmuLa+h4=";
  };

  propagatedBuildInputs = [ inotify-simple ];

  # No tests included
  doCheck = false;
  pythonImportsCheck = [ pname ];

  meta = with lib; {
    description = "Simple recursive inotify watches for Python";
    homepage = "https://github.com/letorbi/inotifyrecursive";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ Flakebi ];
  };
}
