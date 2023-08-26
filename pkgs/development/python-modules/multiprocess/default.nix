{ lib
, buildPythonPackage
, dill
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "multiprocess";
  version = "0.70.15";
  format = "setuptools";

  disabled = pythonOlder "3.6";

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
    changelog = "https://github.com/uqfoundation/multiprocess/releases/tag/multiprocess-${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
