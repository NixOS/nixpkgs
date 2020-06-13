{ lib
, buildPythonPackage
, fetchPypi
, spacy
, cython
, pytest
, boto3
}:

buildPythonPackage rec {
  pname = "neuralcoref";
  version = "4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "23aee7418edf5c2e90b3f9f15931563b07ded8c59de386ae654b403322430ad9";
  };

  propagatedBuildInputs = [
    spacy
    cython
    pytest
    boto3
  ];

  checkInputs = [
    pytest
  ];

  doCheck = false;
  # checkPhase = ''
  #   ${python.interpreter} -m pytest spacy/tests --vectors --models --slow
  # '';

  meta = with lib; {
    description = "Neuralcoref: Coreference Resolution in spaCy with Neural Networks";
    homepage = "https://github.com/huggingface/neuralcoref";
    license = licenses.mit;
    maintainers = with maintainers; [ conradmearns ];
  };
}
