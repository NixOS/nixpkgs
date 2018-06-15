{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname   = "pathspec";
  version = "0.5.6";
  name    = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "be664567cf96a718a68b33329862d1e6f6803ef9c48a6e2636265806cfceb29d";
  };

  meta = {
    description = "Utility library for gitignore-style pattern matching of file paths";
    homepage = "https://github.com/cpburnz/python-path-specification";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ copumpkin ];
  };
}