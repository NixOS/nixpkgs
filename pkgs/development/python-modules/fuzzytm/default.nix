{ buildPythonPackage
, fetchPypi
, lib
, numpy
, pandas
, pyfume
, scipy
}:

buildPythonPackage rec {
  pname = "FuzzyTM";
  version = "2.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IELkjd3/yc2lBYsLP6mms9LEcXOfVtNNooEKCMf9BtU=";
  };

  propagatedBuildInputs = [
    numpy
    pandas
    pyfume
    scipy
  ];

  # Circular dependency on gensim
  doCheck = false;

  meta = with lib; {
    description = "Fuzzy Topic Modeling";
    homepage = "https://github.com/ERijck/FuzzyTM";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
