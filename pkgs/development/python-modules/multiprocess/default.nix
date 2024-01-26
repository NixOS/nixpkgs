{ lib
, buildPythonPackage
, dill
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "multiprocess";
  version = "0.70.15";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "uqfoundation";
    repo = pname;
    rev = "refs/tags/multiprocess-${version}";
    hash = "sha256-fpyFBrQXy5TwbHmce3qg1RiM8JnH3J5skl3es1IQPiw=";
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
