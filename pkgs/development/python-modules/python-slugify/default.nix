{ stdenv, fetchPypi, buildPythonPackage, unidecode, regex, isPy3k }:

buildPythonPackage rec {
    pname = "python-slugify";
    version = "1.2.6";

    src = fetchPypi {
      inherit pname version;
      sha256 = "7723daf30996db26573176bddcdf5fcb98f66dc70df05c9cb29f2c79b8193245";
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
