{ stdenv, fetchPypi, buildPythonPackage, unidecode, regex, isPy3k }:

buildPythonPackage rec {
    pname = "python-slugify";
    version = "2.0.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "d3e034397236020498e677a35e5c05dcc6ba1624b608b9ef7e5fe3090ccbd5a8";
    };
    doCheck = !isPy3k;
    # (only) on python3 unittest loader (loadTestsFromModule) fails

    propagatedBuildInputs = [ unidecode regex ];

    meta = with stdenv.lib; {
      homepage = https://github.com/un33k/python-slugify;
      description = "A Python Slugify application that handles Unicode";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = with maintainers; [ vrthra ];
    };
}
