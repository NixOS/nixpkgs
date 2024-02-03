{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "nose-exclude";
  version = "0.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f78fa8b41eeb815f0486414f710f1eea0949e346cfb11d59ba6295ed69e84304";
  };

  propagatedBuildInputs = [ nose ];

  # "OSError: AF_UNIX path too long" for darwin
  doCheck = !stdenv.isDarwin;

  meta = {
    license = lib.licenses.lgpl21;
    description = "Exclude specific directories from nosetests runs";
    homepage = "https://github.com/kgrandis/nose-exclude";
    maintainers = with lib.maintainers; [ fridh ];
  };
}
