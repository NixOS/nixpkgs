{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname   = "pathspec";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "da45173eb3a6f2a5a487efba21f050af2b41948be6ab52b6a1e3ff22bb8b7061";
  };

  meta = {
    description = "Utility library for gitignore-style pattern matching of file paths";
    homepage = "https://github.com/cpburnz/python-path-specification";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ copumpkin ];
  };
}