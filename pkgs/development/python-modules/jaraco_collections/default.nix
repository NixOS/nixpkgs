{ buildPythonPackage, fetchPypi, setuptools_scm
, six, jaraco_classes }:

buildPythonPackage rec {
  pname = "jaraco.collections";
  version = "1.6.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "332fd500cf13dbaf7ef239741302329b947ba82ce40f5a5e47e790c8714ae0b3";
  };

  doCheck = false;
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six jaraco_classes ];

  # break dependency cycle
  patchPhase = ''
    sed -i "/'jaraco.text',/d" setup.py
  '';
}
