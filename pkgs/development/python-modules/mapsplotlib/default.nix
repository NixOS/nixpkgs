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
  version = "1.1.2";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "99ff773a298bdf0f3185a4c7ac20677a843df818583b368925dcf766cd99f09a";
  };

  propagatedBuildInputs = [ matplotlib scipy pandas requests pillow ];

  meta = with stdenv.lib; {
    description = "Custom Python plots on a Google Maps background";
    homepage = https://github.com/tcassou/mapsplotlib;
    license = licenses.mit;
    maintainers = [ maintainers.rob ];
  };

}
