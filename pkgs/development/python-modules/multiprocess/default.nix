{ lib
, buildPythonPackage
, dill
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "multiprocess";
  version = "0.70.14";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "uqfoundation";
    repo = pname;
    rev = "refs/tags/multiprocess-${version}";
    hash = "sha256-pjYOEOI5No9gT0XchmH6FSJ9uDqEnaLj/PyHT2a90jo=";
  };

  propagatedBuildInputs = [
    dill
  ];

  # Python-version dependent tests
  doCheck = false;

  pythonImportsCheck = [
    "multiprocess"
  ];

  meta = with lib; {
    description = "Multiprocessing and multithreading in Python";
    homepage = "https://github.com/uqfoundation/multiprocess";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
