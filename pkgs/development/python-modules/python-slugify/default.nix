{ stdenv, fetchPypi, buildPythonPackage, unidecode, regex, isPy3k }:

buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "python-slugify";
    version = "1.2.5";

    src = fetchPypi {
      inherit pname version;
      sha256 = "5dbb360b882b2dabe0471a1a92f604504d83c2a73c71f2098d004ab62e695534";
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
