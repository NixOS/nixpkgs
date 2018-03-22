{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname   = "pathspec";
  version = "0.5.5";
  name    = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "72c495d1bbe76674219e307f6d1c6062f2e1b0b483a5e4886435127d0df3d0d3";
  };

  meta = {
    description = "Utility library for gitignore-style pattern matching of file paths";
    homepage = "https://github.com/cpburnz/python-path-specification";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ copumpkin ];
  };
}