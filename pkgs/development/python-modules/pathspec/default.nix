{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname   = "pathspec";
  version = "0.5.3";
  name    = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "54478a66a360f4ebe4499c9235e4206fca5dec837b8e272d1ce37e0a626cc64d";
  };

  meta = {
    description = "Utility library for gitignore-style pattern matching of file paths";
    homepage = "https://github.com/cpburnz/python-path-specification";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ copumpkin ];
  };
}