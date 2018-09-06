{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname   = "pathspec";
  version = "0.5.7";
  name    = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "69ac7869c9ce308cfe631e29c09f9da60fae02baf31418885bbbb0c75adcd8c5";
  };

  meta = {
    description = "Utility library for gitignore-style pattern matching of file paths";
    homepage = "https://github.com/cpburnz/python-path-specification";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ copumpkin ];
  };
}