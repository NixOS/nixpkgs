{ stdenv, buildPythonPackage, isPyPy, fetchPypi
, cffi, pycparser, mock, pytest, py, six }:

with stdenv.lib;

buildPythonPackage rec {
  version = "3.1.6";
  pname = "bcrypt";

  src = fetchPypi {
    inherit pname version;
    sha256 = "44636759d222baa62806bbceb20e96f75a015a6381690d1bc2eda91c01ec02ea";
  };
  buildInputs = [ pycparser mock pytest py ];
  propagatedBuildInputs = [ six ] ++ optional (!isPyPy) cffi;

  meta = {
    maintainers = with maintainers; [ domenkozar ];
    description = "Modern password hashing for your software and your servers";
    license = licenses.asl20;
    homepage = https://github.com/pyca/bcrypt/;
  };
}
