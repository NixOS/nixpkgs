{ stdenv, buildPythonPackage, isPyPy, fetchurl
, cffi, pycparser, mock, pytest, py, six }:

with stdenv.lib;

buildPythonPackage rec {
  version = "3.1.4";
  pname = "bcrypt";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/b/bcrypt/${name}.tar.gz";
    sha256 = "67ed1a374c9155ec0840214ce804616de49c3df9c5bc66740687c1c9b1cd9e8d";
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
