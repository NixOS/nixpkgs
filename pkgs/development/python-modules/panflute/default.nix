{ lib
, fetchPypi
, click
, pyyaml
, buildPythonPackage
, isPy3k
}:

buildPythonPackage rec{
  version = "2.1.0";
  pname = "panflute";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8a3d5dd2a10c3aa6fa8167713fedb47400f0e8ae6ea8346fd4b599842bb1882d";
  };

  propagatedBuildInputs = [ click pyyaml ];

  meta = with lib; {
    description = "A Pythonic alternative to John MacFarlane's pandocfilters, with extra helper functions";
    homepage = "http://scorreia.com/software/panflute";
    license = licenses.bsd3;
    maintainers = with maintainers; [ synthetica ];
  };
}
