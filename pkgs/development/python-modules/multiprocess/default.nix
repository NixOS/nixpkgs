{ lib
, buildPythonPackage
, dill
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "multiprocess";
  version = "0.70.12.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "uqfoundation";
    repo = pname;
    rev = "multiprocess-${version}";
    sha256 = "1npikdgj0qriqj384vg22qgq2xqylypk67sx1qfmdzvk6c4iyg0w";
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
