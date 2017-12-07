{ stdenv, fetchPypi, buildPythonPackage, defusedxml }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "PyAMF";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1r3lp9gkph48g9lijby5rs5daa3lhxs204r14zw4kvp3hf4xcm84";
  };

  propagatedBuildInputs = [ defusedxml ];

  meta = with stdenv.lib; {
    description = "AMF (Action Message Format) support for Python";
    homepage = https://pypi.python.org/pypi/PyAMF;
    license = licenses.mit;
  };
}
