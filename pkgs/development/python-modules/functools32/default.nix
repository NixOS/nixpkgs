{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

if isPy3k then null else buildPythonPackage rec {
  pname = "functools32";
  version = "3.2.3-2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0v8ya0b58x47wp216n1zamimv4iw57cxz3xxhzix52jkw3xks9gn";
  };

  meta = with lib; {
    description = "This is a backport of the functools standard library module from";
    homepage = "https://github.com/MiCHiLU/python-functools32";
    license = licenses.psfl;
  };

}
