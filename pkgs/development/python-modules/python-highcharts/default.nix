{ lib, buildPythonPackage, fetchPypi, future, jinja2, setuptools }:

buildPythonPackage rec {
  pname = "python-highcharts";
  version = "0.4.2";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "c0f865f982da4c1d276f665f6633b30053b5bc4e8943d67b988379c3411d9d6b";
  };
  
  propagatedBuildInputs = [ future jinja2 setuptools ];
  
  meta = with lib; {
    description = "Python Highcharts wrapper";
    homepage = "https://github.com/kyper-data/python-highcharts";
    license = licenses.mit;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
