{ lib
, fetchPypi
, click
, pyyaml
, buildPythonPackage
, isPy3k
}:

buildPythonPackage rec{
  version = "2.1.3";
  pname = "panflute";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "y5QkT+dmiTuy8XLruCfsPe12G4//qE5MhLZ4ufip/5U=";
  };

  propagatedBuildInputs = [
    click
    pyyaml
  ];

  meta = with lib; {
    description = "A Pythonic alternative to John MacFarlane's pandocfilters, with extra helper functions";
    homepage = "http://scorreia.com/software/panflute";
    license = licenses.bsd3;
    maintainers = with maintainers; [ synthetica ];
  };
}
