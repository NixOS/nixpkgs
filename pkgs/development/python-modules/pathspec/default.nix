{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname   = "pathspec";
  version = "0.5.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "54a5eab895d89f342b52ba2bffe70930ef9f8d96e398cccf530d21fa0516a873";
  };

  meta = {
    description = "Utility library for gitignore-style pattern matching of file paths";
    homepage = "https://github.com/cpburnz/python-path-specification";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ copumpkin ];
  };
}