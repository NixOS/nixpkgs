{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
, numpy
}:

buildPythonPackage rec {
  pname = "langid";
  version = "1.1.6";
  format = "setuptools";

  src = fetchPypi { # use PyPi as source, github repository does not contain tags or release branches
    inherit pname version;
    hash = "sha256-BEvK4ZEtq4XDPY6Y8oEbj0/xIT5emp6VEBN7hNosspM=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    numpy
  ];

  doCheck = false; # Package has no tests
  pythonImportsCheck = [ "langid" ];

  meta = with lib; {
    description = "Langid.py is a standalone Language Identification (LangID) tool";
    homepage = "https://pypi.org/project/langid/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
