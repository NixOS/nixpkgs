{ lib, stdenv, fetchPypi, buildPythonPackage, python, text-unidecode }:

buildPythonPackage rec {
    pname = "python-slugify";
    version = "4.0.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "69a517766e00c1268e5bbfc0d010a0a8508de0b18d30ad5a1ff357f8ae724270";
    };

    propagatedBuildInputs = [ text-unidecode ];

    checkPhase = ''
      ${python.interpreter} test.py
    '';

    meta = with lib; {
      homepage = "https://github.com/un33k/python-slugify";
      description = "A Python Slugify application that handles Unicode";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = with maintainers; [ vrthra ];
    };
}
