{ stdenv, buildPythonPackage, fetchPypi, numpy, scipy, six, decorator }:

buildPythonPackage rec {
  pname = "paramz";
  version = "0.9.4";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "179ca77a965e6e724217257793e3c8c022285ea2190a85e0826ac98dea316219";
  };

  propagatedBuildInputs = [ numpy scipy six decorator ];

  meta = with stdenv.lib; {
    description = "Parameterization framework for parameterized model creation and handling";
    homepage = https://github.com/sods/paramz;
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
