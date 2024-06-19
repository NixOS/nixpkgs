{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "inotify-simple";
  version = "1.3.5";
  format = "setuptools";

  src = fetchPypi {
    pname = "inotify_simple";
    inherit version;
    sha256 = "0a61bh087cq5wfrvz680hg5pmykb9gmy26kwyn6ims2akkjgyh44";
  };

  # The package has no tests
  doCheck = false;

  pythonImportsCheck = [ "inotify_simple" ];

  meta = with lib; {
    description = "A simple Python wrapper around inotify";
    homepage = "https://github.com/chrisjbillington/inotify_simple";
    license = licenses.bsd2;
    maintainers = with maintainers; [ erikarvstedt ];
  };
}
