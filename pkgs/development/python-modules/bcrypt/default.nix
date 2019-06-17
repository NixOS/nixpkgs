{ lib, buildPythonPackage, isPyPy, fetchPypi
, libffi
, cffi, pycparser, mock, pytest, py, six }:

buildPythonPackage rec {
  pname = "bcrypt";
  version = "3.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "44636759d222baa62806bbceb20e96f75a015a6381690d1bc2eda91c01ec02ea";
  };

  buildInputs = [ libffi pycparser mock pytest py ];

  propagatedBuildInputs = [ six ] ++ lib.optional (!isPyPy) cffi;

  meta = with lib; {
    description = "Modern password hashing for your software and your servers";
    homepage = https://github.com/pyca/bcrypt/;
    license = licenses.asl20;
    maintainers = with maintainers; [ domenkozar ];
  };
}
