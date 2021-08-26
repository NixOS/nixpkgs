{ buildPythonPackage, fetchPypi, setuptools-scm
, six, jaraco_classes, jaraco_text
}:

buildPythonPackage rec {
  pname = "jaraco.collections";
  version = "3.3.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "3662267424b55f10bf15b6f5dee6a6e48a2865c0ec50cc7a16040c81c55a98dc";
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
