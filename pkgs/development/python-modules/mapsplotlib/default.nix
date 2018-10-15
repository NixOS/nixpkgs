{ stdenv
, buildPythonPackage
, isPy3k
, fetchPypi
, matplotlib
, scipy
, pandas
, requests
, pillow
}:

buildPythonPackage rec {
  pname = "mapsplotlib";
  version = "1.0.6";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "09gpws3x0jd88n636baxx5izjffrpjy4j6jl8l7vj29yzvrdr2bp";
  };

  propagatedBuildInputs = [ matplotlib scipy pandas requests pillow ];

  meta = with stdenv.lib; {
    description = "Custom Python plots on a Google Maps background";
    homepage = https://github.com/tcassou/mapsplotlib;
    license = licenses.mit;
    maintainers = [ maintainers.rob ];
  };

}
