{ stdenv, fetchPypi, buildPythonPackage, python, text-unidecode }:

buildPythonPackage rec {
    pname = "python-slugify";
    version = "3.0.4";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0dv97yi5fq074q5qyqbin09pmi8ixg36caf5nkpw2bqkd8jh6pap";
    };

    propagatedBuildInputs = [ text-unidecode ];

    checkPhase = ''
      ${python.interpreter} test.py
    '';

    meta = with stdenv.lib; {
      homepage = https://github.com/un33k/python-slugify;
      description = "A Python Slugify application that handles Unicode";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = with maintainers; [ vrthra ];
    };
}
