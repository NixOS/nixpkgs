{ stdenv, buildPythonPackage, fetchPypi, librosa, tqdm, numpy, jams, requests
, sortedcontainers, mir_eval, pandas, jsonschema, future }:

buildPythonPackage rec {
  pname = "mirdata";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ebe38f2cc51a1ab640c634014f1524a5e253b0beb593eee0459f9526a50af80";
  };

  propagatedBuildInputs = [
    tqdm
    librosa
    numpy
    jams
    requests
    sortedcontainers
    mir_eval
    pandas
    jsonschema
    future
  ];
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/mir-dataset-loaders/mirdata";
    description = "common loaders for mir datasets";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jmorag ];
  };

}
