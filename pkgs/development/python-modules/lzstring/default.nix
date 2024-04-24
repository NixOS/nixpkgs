{ lib
, buildPythonPackage
, fetchPypi
, future
}:

buildPythonPackage rec {
  pname   = "lzstring";
  version = "1.0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18ly9pppy2yspxzw7k1b23wk77k7m44rz2g0271bqgqrk3jn3yhs";
  };

  propagatedBuildInputs = [ future ];

  meta = {
    description = "lz-string for python";
    homepage    = "https://github.com/gkovacs/lz-string-python";
    license     = lib.licenses.mit;
    maintainers = with lib.maintainers; [ obadz ];
  };
}
