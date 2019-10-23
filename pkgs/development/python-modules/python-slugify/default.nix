{ stdenv, fetchPypi, buildPythonPackage, python, text-unidecode }:

buildPythonPackage rec {
    pname = "python-slugify";
    version = "3.0.6";

    src = fetchPypi {
      inherit pname version;
      sha256 = "8653d589308c91c67fe5c97a2afda0cfac9492061e69c0db90d1aef68fcd2332";
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
