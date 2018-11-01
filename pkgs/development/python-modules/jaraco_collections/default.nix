{ buildPythonPackage, fetchPypi, setuptools_scm
, six, jaraco_classes }:

buildPythonPackage rec {
  pname = "jaraco.collections";
  version = "1.5.3";
  src = fetchPypi {
    inherit pname version;
    sha256 = "05cmcq5k39bx73kjr00xfm2yr0npyrv89cxdh41ni6x8pkki1jyr";
  };

  doCheck = false;
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six jaraco_classes ];

  # break dependency cycle
  patchPhase = ''
    sed -i "/'jaraco.text',/d" setup.py
  '';
}
