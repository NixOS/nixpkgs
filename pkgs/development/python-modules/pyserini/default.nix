{ lib
, fetchPypi
, fetchurl
, buildPythonPackage
, pythonOlder
, faiss
, lightgbm
, nmslib
, onnxruntime
, openai
, openjdk
, pandas
, pybind11
, pyjnius
, pyyaml
, sentencepiece
, spacy
, tiktoken
, torch
, transformers
}:

buildPythonPackage rec {
  pname = "pyserini";
  version = "0.23.0";

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-poZkhJ4DldB+qIJr6Kdt+ux+UBE/5EtwMs1lytDrpXA=";
  };

  postPatch = ''
    sed -i "/pyserini_packages.remove('tests')/d" setup.py
  '';

  propagatedBuildInputs = [
    faiss
    lightgbm
    nmslib
    onnxruntime
    openjdk
    openai
    pandas
    pybind11
    pyjnius
    pyyaml
    sentencepiece
    spacy
    tiktoken
    torch
    transformers
  ];

  preCheck = ''
    export TRANSFORMERS_CACHE=$NIX_BUILD_TOP/cache
  '';

  # tests try to fetch files from the Internet
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/castorini/pyserini";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      # contains Anserini (https://github.com/castorini/anserini) as .jar
    ];
    description = "A Python toolkit for reproducible information retrieval research with sparse and dense representations";
    maintainers = [ maintainers.gm6k ];
  };
}
