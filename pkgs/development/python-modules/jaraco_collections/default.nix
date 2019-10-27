{ buildPythonPackage, fetchPypi, setuptools_scm
, six, jaraco_classes, jaraco_text
}:

buildPythonPackage rec {
  pname = "jaraco.collections";
  version = "2.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "0e4c278310a5e1ecd565f09555b89ed923cac100b2525797201d2a89dcab337c";
  };

  doCheck = false;
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six jaraco_classes jaraco_text ];

  # break dependency cycle
  patchPhase = ''
    sed -i "/'jaraco.text',/d" setup.py
  '';
}
