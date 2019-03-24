{ buildPythonPackage, fetchPypi, setuptools_scm
, six, jaraco_classes, jaraco_text
}:

buildPythonPackage rec {
  pname = "jaraco.collections";
  version = "2.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "eb43fb9a7b29cff20767caf838c14bdf80a89395aba67a97d61c8f16e0e22c97";
  };

  doCheck = false;
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six jaraco_classes jaraco_text ];

  # break dependency cycle
  patchPhase = ''
    sed -i "/'jaraco.text',/d" setup.py
  '';
}
