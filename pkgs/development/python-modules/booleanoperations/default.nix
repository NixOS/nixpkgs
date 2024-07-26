{ lib, buildPythonPackage, fetchPypi
, fonttools, fs, pyclipper, defcon, fontpens
, setuptools-scm, pytest
}:

buildPythonPackage rec {
  pname = "booleanOperations";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f41lb19m8azchl1aqz6j5ycbspb8jsf1cnn42hlydxd68f85ylc";
    extension = "zip";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    fonttools
    fs
    pyclipper
    defcon
    fontpens
  ];

  nativeCheckInputs = [ pytest ];

  meta = with lib; {
    description = "Boolean operations on paths";
    homepage = "https://github.com/typemytype/booleanOperations";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
