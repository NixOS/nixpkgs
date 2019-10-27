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
  version = "1.1.3";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9214a2ddc5157fc6fef7659db7c1fa1c096b4d79f543cc2eeb2c5fc706b89c98";
  };

  propagatedBuildInputs = [ matplotlib scipy pandas requests pillow ];

  meta = with stdenv.lib; {
    description = "Custom Python plots on a Google Maps background";
    homepage = https://github.com/tcassou/mapsplotlib;
    license = licenses.mit;
    maintainers = [ maintainers.rob ];
  };

}
