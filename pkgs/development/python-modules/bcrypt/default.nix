{ lib, buildPythonPackage, isPyPy, fetchPypi, pythonOlder
, cffi, pycparser, mock, pytest, py, six }:

buildPythonPackage rec {
  version = "3.2.0";
  pname = "bcrypt";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5b93c1726e50a93a033c36e5ca7fdcd29a5c7395af50a6892f5d9e7c6cfbfb29";
  };

  buildInputs = [ pycparser mock pytest py ];

  propagatedBuildInputs = [ six ] ++ lib.optional (!isPyPy) cffi;

  meta = with lib; {
    maintainers = with maintainers; [ domenkozar ];
    description = "Modern password hashing for your software and your servers";
    license = licenses.asl20;
    homepage = "https://github.com/pyca/bcrypt/";
  };
}
