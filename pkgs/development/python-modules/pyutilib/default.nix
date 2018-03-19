{ lib
, buildPythonPackage
, fetchPypi
, nose
, six
}:

buildPythonPackage rec {
  pname = "PyUtilib";
  version = "5.6.2";

  propagatedBuildInputs = [ six nose ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "17rynkkq728b7iy65m2rz9gcycipk0r8xiplfb5lvg5l27zm52gv";
  };

  # Tests requires text files that are not included in the pypi package
  doCheck = false;

  meta = with lib; {
    homepage    = https://github.com/PyUtilib/pyutilib;
    description = "collection of Python utilities";
    longDescription = ''
      The PyUtilib project supports a collection of Python utilities, including
      a well-developed component architecture and extensions to the PyUnit testing
      framework.
    '';
    license     = licenses.bsdOriginal;
    maintainers = with maintainers; [ ericsagnes ];
  };
}
