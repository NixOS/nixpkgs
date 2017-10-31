{ stdenv, buildPythonPackage, fetchPypi, numpy, scipy, six, decorator }:

buildPythonPackage rec {
  pname = "paramz";
  version = "0.8.5";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "297e59b48e57e78e15f547b1af8b21ddfd19a6312d70b9dc07c7262711adfed9";
  };

  propagatedBuildInputs = [ numpy scipy six decorator ];

  meta = with stdenv.lib; {
    description = "Parameterization framework for parameterized model creation and handling";
    homepage = https://github.com/sods/paramz;
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
