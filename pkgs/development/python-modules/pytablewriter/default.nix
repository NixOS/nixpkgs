{ buildPythonPackage
, dataproperty
, mbstrdecoder
, pathvalidate
, setuptools
, tabledata
, tcolorpy
, typepy

, fetchFromGitHub
, lib
}:

buildPythonPackage rec {
  pname = "pytablewriter";
  version = "0.64.2";

  propagatedBuildInputs = [ dataproperty mbstrdecoder pathvalidate setuptools tabledata tcolorpy typepy ];

  doCheck = false;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+IOHnmdd9g3SoHyITJJtbJ0/SAAmwWmwX5XeqsO34EM=";
  };

  meta = with lib; {
    homepage = "https://github.com/thombashi/pytablewriter";
    description = "pytablewriter is a python library to write a table in various formats";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.mit;
  };
}
