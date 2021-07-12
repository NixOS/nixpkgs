{ lib
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
  version = "1.2.1";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7650754e3175f13a1cb4406a62e4cfeb424036377992b9c3c2e3f6c2404d06b3";
  };

  propagatedBuildInputs = [ matplotlib scipy pandas requests pillow ];

  meta = with lib; {
    description = "Custom Python plots on a Google Maps background";
    homepage = "https://github.com/tcassou/mapsplotlib";
    license = licenses.mit;
    maintainers = [ maintainers.rob ];
  };

}
