{ lib
, fetchPypi
, click
, pyyaml
, buildPythonPackage
, isPy3k
}:

buildPythonPackage rec{
  version = "2.0.5";
  pname = "panflute";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ssmqcyr91f0gpl49lz6a9jkl17l06h6qcik24rlmva28ii6aszz";
  };

  propagatedBuildInputs = [ click pyyaml ];

  meta = with lib; {
    description = "A Pythonic alternative to John MacFarlane's pandocfilters, with extra helper functions";
    homepage = "http://scorreia.com/software/panflute";
    license = licenses.bsd3;
    maintainers = with maintainers; [ synthetica ];
  };
}
