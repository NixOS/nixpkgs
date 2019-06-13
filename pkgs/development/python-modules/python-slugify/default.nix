{ stdenv, fetchPypi, buildPythonPackage, python, text-unidecode }:

buildPythonPackage rec {
    pname = "python-slugify";
    version = "3.0.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "57163ffb345c7e26063435a27add1feae67fa821f1ef4b2f292c25847575d758";
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
