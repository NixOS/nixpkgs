{ lib
, fetchPypi
, click
, pyyaml
, buildPythonPackage
, isPy3k
, fetchpatch
}:

buildPythonPackage rec{
  version = "2.1.0";
  pname = "panflute";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8a3d5dd2a10c3aa6fa8167713fedb47400f0e8ae6ea8346fd4b599842bb1882d";
  };
  patches = [
    # Upstream has relaxed the version constaints for the click dependency
    # but there hasn't been a release since then
    (fetchpatch {
      url = "https://github.com/sergiocorreia/panflute/commit/dee6c716a73072a968d67f8638a61de44025d8de.patch";
      sha256 = "sha256-Kj/NTcXsSkevpfr8OwoIQi0p6ChXDM6YgYDPNHJtJZo=";
    })
  ];

  propagatedBuildInputs = [ click pyyaml ];

  meta = with lib; {
    description = "A Pythonic alternative to John MacFarlane's pandocfilters, with extra helper functions";
    homepage = "http://scorreia.com/software/panflute";
    license = licenses.bsd3;
    maintainers = with maintainers; [ synthetica ];
  };
}
