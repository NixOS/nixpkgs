{ lib, fetchurl, buildPythonPackage
, numpy, scikit-learn, pybind11, setuptools-scm, cython
, pytestCheckHook }:

buildPythonPackage rec {
  pname = "hmmlearn";
  version = "0.2.7";

  src = fetchurl {
    url = "mirror://pypi/h/hmmlearn/${pname}-${version}.tar.gz";
    sha256 = "sha256-a0snIPJ6912pNnq02Q3LAPONozFo322Rf57F3mZw9uE=";
  };

  buildInputs = [ setuptools-scm cython pybind11 ];
  propagatedBuildInputs = [ numpy scikit-learn ];
  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hmmlearn" ];
  pytestFlagsArray = [ "--pyargs" "hmmlearn" ];

  meta = with lib; {
    description = "Hidden Markov Models in Python with scikit-learn like API";
    homepage    = "https://github.com/hmmlearn/hmmlearn";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ abbradar ];
  };
}
