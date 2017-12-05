{ stdenv, buildPythonPackage, fetchPypi, numpy, scipy, six, decorator }:

buildPythonPackage rec {
  pname = "paramz";
  version = "0.7.4";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1r4mayzp7cb5w1kz45sw65is9j3p60h0yyp8hdhsx393rr4n82nn";
  };

  propagatedBuildInputs = [ numpy scipy six decorator ];

  meta = with stdenv.lib; {
    description = "Parameterization framework for parameterized model creation and handling";
    homepage = https://github.com/sods/paramz;
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
