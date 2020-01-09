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
  version = "1.2.0";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e0a18aa0d134407aab6130c314596732d129ff98f9a6084640a07a5b8656f836";
  };

  propagatedBuildInputs = [ matplotlib scipy pandas requests pillow ];

  meta = with stdenv.lib; {
    description = "Custom Python plots on a Google Maps background";
    homepage = https://github.com/tcassou/mapsplotlib;
    license = licenses.mit;
    maintainers = [ maintainers.rob ];
  };

}
