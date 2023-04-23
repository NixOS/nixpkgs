{ lib
, fetchPypi
, buildPythonPackage
, click
, numpy
, setuptools
, setuptools-scm
, uhi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "histoprint";
  version = "2.4.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "328f789d186e3bd76882d57b5aad3fa08c7870a856cc83bcdbad9f4aefbda94d";
  };

  buildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    click
    numpy
    uhi
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Pretty print histograms to the console";
    homepage = "https://github.com/scikit-hep/histoprint";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
