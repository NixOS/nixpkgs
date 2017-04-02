{ stdenv, buildPythonPackage, isPyPy, fetchurl
, cffi, pycparser, mock, pytest, py }:

with stdenv.lib;

buildPythonPackage rec {
  name = "bcrypt-${version}";
  version = "3.1.2";

  src = fetchurl {
    url = "mirror://pypi/b/bcrypt/${name}.tar.gz";
    sha256 = "1al54xafv1aharpb22yv5rjjc63fm60z3pn2shbiq48ah9f1fvil";
  };
  buildInputs = [ pycparser mock pytest py ];
  propagatedBuildInputs = optional (!isPyPy) cffi;

  meta = {
    maintainers = with maintainers; [ domenkozar ];
    description = "Modern password hashing for your software and your servers";
    license = licenses.asl20;
    homepage = https://github.com/pyca/bcrypt/;
  };
}
