{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, click
, joblib
, regex
, tqdm
}:

buildPythonPackage rec {
  pname = "nltk";
  version = "3.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-1lB9ZGDOx21wr+pCQqImp1QvhcZpF3ucf1YrfPGwVQI=";
  };

  propagatedBuildInputs = [
    click
    joblib
    regex
    tqdm
  ];

  # Tests require some data, the downloading of which is impure. It would
  # probably make sense to make the data another derivation, but then feeding
  # that into the tests (given that we need nltk itself to download the data,
  # unless there's an easy way to download it without nltk's downloader) might
  # be complicated. For now let's just disable the tests and hope for the
  # best.
  doCheck = false;

  pythonImportsCheck = [
    "nltk"
  ];

  meta = with lib; {
    description = "Natural Language Processing ToolKit";
    homepage = "http://nltk.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ lheckemann ];
  };
}
