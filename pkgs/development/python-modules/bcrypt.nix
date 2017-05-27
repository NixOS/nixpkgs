{ stdenv, buildPythonPackage, isPyPy, fetchurl
, cffi, pycparser, mock, pytest, py, six }:

with stdenv.lib;

buildPythonPackage rec {
  version = "3.1.2";
  pname = "bcrypt";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/b/bcrypt/${name}.tar.gz";
    sha256 = "1al54xafv1aharpb22yv5rjjc63fm60z3pn2shbiq48ah9f1fvil";
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
