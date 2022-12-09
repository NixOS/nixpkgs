{ lib
, buildPythonPackage
, dill
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "multiprocess";
  version = "0.70.13";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "uqfoundation";
    repo = pname;
    rev = "refs/tags/multiprocess-${version}";
    sha256 = "sha256-L/PesvaidavDEgJGqBxwcCYtG9TlKSwaxrUMJ+XVFOM=";
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
