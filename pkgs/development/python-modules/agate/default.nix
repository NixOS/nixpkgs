{ stdenv, fetchPypi, buildPythonPackage, isPy3k,
  discid, six, parsedatetime, isodate, Babel, pytimeparse,
  leather, python-slugify }:

buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "agate";
    version = "1.6.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "02pb5jjvzjqfpsa7q12afbk9nqj06xdpw1s7qa6a1bnalikfniqm";
    };

    propagatedBuildInputs = [ discid six parsedatetime
         isodate Babel pytimeparse leather python-slugify ];

    doCheck = !isPy3k;
    # (only) on python3 unittest loader (loadTestsFromModule) fails

    meta = with stdenv.lib; {
      description = "A Python data analysis library that is optimized for humans instead of machines";
      homepage    = https://github.com/wireservice/agate;
      license     = with licenses; [ mit ];
      maintainers = with maintainers; [ vrthra ];
    };
}
