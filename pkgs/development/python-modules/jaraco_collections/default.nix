{ buildPythonPackage, fetchPypi, setuptools_scm
, six, jaraco_classes, jaraco_text
}:

buildPythonPackage rec {
  pname = "jaraco.collections";
  version = "2.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "0z1kmgf8jahx42bmflmj030wl8yrksw5b5ghcpayrqd5221jfk0f";
  };

  doCheck = false;
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six jaraco_classes jaraco_text ];

  # break dependency cycle
  patchPhase = ''
    sed -i "/'jaraco.text',/d" setup.py
  '';
}
