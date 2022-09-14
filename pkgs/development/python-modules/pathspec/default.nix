{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname   = "pathspec";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-es5hYbYh0x55AutrWuFI0Sz9I/SiSbn/trn+4SCEMj0=";
  };

  meta = {
    description = "Utility library for gitignore-style pattern matching of file paths";
    homepage = "https://github.com/cpburnz/python-path-specification";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ copumpkin ];
  };
}
