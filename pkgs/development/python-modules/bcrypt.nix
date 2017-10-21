{ stdenv, buildPythonPackage, isPyPy, fetchurl
, cffi, pycparser, mock, pytest, py, six }:

with stdenv.lib;

buildPythonPackage rec {
  version = "3.1.3";
  pname = "bcrypt";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/b/bcrypt/${name}.tar.gz";
    sha256 = "6645c8d0ad845308de3eb9be98b6fd22a46ec5412bfc664a423e411cdd8f5488";
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
