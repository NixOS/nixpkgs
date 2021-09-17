{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname   = "pathspec";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e564499435a2673d586f6b2130bb5b95f04a3ba06f81b8f895b651a3c76aabb1";
  };

  meta = {
    description = "Utility library for gitignore-style pattern matching of file paths";
    homepage = "https://github.com/cpburnz/python-path-specification";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ copumpkin ];
  };
}
