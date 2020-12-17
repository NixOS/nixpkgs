{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname   = "pathspec";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "86379d6b86d75816baba717e64b1a3a3469deb93bb76d613c9ce79edc5cb68fd";
  };

  meta = {
    description = "Utility library for gitignore-style pattern matching of file paths";
    homepage = "https://github.com/cpburnz/python-path-specification";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ copumpkin ];
  };
}
