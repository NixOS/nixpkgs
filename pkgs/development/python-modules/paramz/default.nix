{ stdenv, buildPythonPackage, fetchPypi, numpy, scipy, six, decorator }:

buildPythonPackage rec {
  pname = "paramz";
  version = "0.9.1";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8a5a2fe5cdb033eb869c49e81fde2a9d0055fadb53a8af1665a7f48f320179cf";
  };

  propagatedBuildInputs = [ numpy scipy six decorator ];

  meta = with stdenv.lib; {
    description = "Parameterization framework for parameterized model creation and handling";
    homepage = https://github.com/sods/paramz;
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
