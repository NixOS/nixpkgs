{ stdenv, fetchPypi, buildPythonPackage, unidecode, regex, isPy3k }:

buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "python-slugify";
    version = "1.2.4";

    src = fetchPypi {
      inherit pname version;
      sha256 = "097qllxys22kghcv2a5jcc1zdlr9zzqayvk6ywavsv8wgbgqb8sp";
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
