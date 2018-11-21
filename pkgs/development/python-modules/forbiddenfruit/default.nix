{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "0.1.0";
  pname = "forbiddenfruit";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xra2kw6m8ag29ifwmhi5zqksh4cr0yy1waqd488rm59kcr3zl79";
  };

  meta = with stdenv.lib; {
    description = "Patch python built-in objects";
    homepage = https://pypi.python.org/pypi/forbiddenfruit;
    license = licenses.mit;
  };

}
