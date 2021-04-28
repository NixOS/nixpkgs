{ buildPythonPackage, fetchPypi, setuptools_scm
, six, jaraco_classes, jaraco_text
}:

buildPythonPackage rec {
  pname = "jaraco.collections";
  version = "3.2.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "6d179770493c4f5802395ae5a29e07c66d826dc3cd680ad0b0f0fb9fd6cdf533";
  };

  pythonNamespaces = [ "jaraco" ];

  doCheck = false;
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six jaraco_classes jaraco_text ];

  # break dependency cycle
  patchPhase = ''
    sed -i "/'jaraco.text',/d" setup.py
  '';
}
