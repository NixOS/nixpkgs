{ buildPythonPackage
, lib
, fetchPypi
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "pluggy";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ddc32f03971bfdf900a81961a48ccf2fb677cf7715108f85295c67405798616";
  };

  checkPhase = ''
    py.test
  '';

  # To prevent infinite recursion with pytest
  doCheck = false;

  buildInputs = [ setuptools_scm ];

  meta = {
    description = "Plugin and hook calling mechanisms for Python";
    homepage = "https://pypi.python.org/pypi/pluggy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jgeerds ];
  };
}