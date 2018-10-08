{ stdenv
, buildPythonPackage
, fetchPypi
, python
, pythonAtLeast
}:

if pythonAtLeast "3.4" then null else buildPythonPackage rec {
  pname = "enum34";
  version = "1.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1";
  };

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/enum34;
    description = "Python 3.4 Enum backported to 3.3, 3.2, 3.1, 2.7, 2.6, 2.5, and 2.4";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
