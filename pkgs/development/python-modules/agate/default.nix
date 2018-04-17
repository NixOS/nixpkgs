{ stdenv, fetchPypi, buildPythonPackage, isPy3k,
  discid, six, parsedatetime, isodate, Babel, pytimeparse,
  leather, python-slugify }:

buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "agate";
    version = "1.6.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "c93aaa500b439d71e4a5cf088d0006d2ce2c76f1950960c8843114e5f361dfd3";
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
