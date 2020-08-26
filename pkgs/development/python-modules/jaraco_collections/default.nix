{ buildPythonPackage, fetchPypi, setuptools_scm
, six, jaraco_classes, jaraco_text
}:

buildPythonPackage rec {
  pname = "jaraco.collections";
  version = "3.0.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "be570ef4f2e7290b757449395238fa63d70a9255574624e73c5ff9f1ee554721";
  };

  doCheck = false;
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six jaraco_classes jaraco_text ];

  # break dependency cycle
  patchPhase = ''
    sed -i "/'jaraco.text',/d" setup.py
  '';
}
