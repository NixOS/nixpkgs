{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname   = "pathspec";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0p7ab7jx3wgg7xdj2q8yk99cz3xv2a5p1r8q9kfylnvqn34cr1g2";
  };

  meta = {
    description = "Utility library for gitignore-style pattern matching of file paths";
    homepage = "https://github.com/cpburnz/python-path-specification";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ copumpkin ];
  };
}