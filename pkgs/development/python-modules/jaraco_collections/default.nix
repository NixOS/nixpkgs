{ buildPythonPackage, fetchPypi, setuptools-scm
, six, jaraco_classes, jaraco_text
}:

buildPythonPackage rec {
  pname = "jaraco.collections";
  version = "3.4.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "344d14769d716e7496af879ac71b3c6ebdd46abc64bd9ec21d15248365aa3ac9";
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
