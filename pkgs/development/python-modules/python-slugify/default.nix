{ stdenv, fetchPypi, buildPythonPackage, python, text-unidecode }:

buildPythonPackage rec {
    pname = "python-slugify";
    version = "4.0.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "a8fc3433821140e8f409a9831d13ae5deccd0b033d4744d94b31fea141bdd84c";
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
