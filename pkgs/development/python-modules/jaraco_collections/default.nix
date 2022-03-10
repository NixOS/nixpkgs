{ buildPythonPackage, fetchPypi, setuptools-scm
, six, jaraco_classes, jaraco_text
}:

buildPythonPackage rec {
  pname = "jaraco.collections";
  version = "3.5.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "b04f00bd4b3c4fc4ba5fe1baf8042c0efd192b13e386830ea23fff77bb69dc88";
  };

  pythonNamespaces = [ "jaraco" ];

  doCheck = false;
  buildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ six jaraco_classes jaraco_text ];

  # break dependency cycle
  patchPhase = ''
    sed -i "/'jaraco.text',/d" setup.py
  '';
}
