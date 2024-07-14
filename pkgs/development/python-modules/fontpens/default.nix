{
  lib,
  buildPythonPackage,
  fetchPypi,
  fonttools,
}:

buildPythonPackage rec {
  pname = "fontpens";
  version = "0.2.4";

  src = fetchPypi {
    pname = "fontPens";
    inherit version;
    hash = "sha256-ptmhRXOzRQ8zE9aVI/kAYCjCH8eu9dNTM7h6q38rQf0=";
    extension = "zip";
  };

  propagatedBuildInputs = [ fonttools ];

  # can't run normal tests due to circular dependency with fontParts
  doCheck = false;
  pythonImportsCheck =
    [ "fontPens" ]
    ++ (builtins.map (s: "fontPens." + s) [
      "angledMarginPen"
      "digestPointPen"
      "flattenPen"
      "guessSmoothPointPen"
      "marginPen"
      "penTools"
      "printPen"
      "printPointPen"
      "recordingPointPen"
      "thresholdPen"
      "thresholdPointPen"
      "transformPointPen"
    ]);

  meta = with lib; {
    description = "Collection of classes implementing the pen protocol for manipulating glyphs";
    homepage = "https://github.com/robotools/fontPens";
    license = licenses.bsd3;
    maintainers = [ maintainers.sternenseemann ];
  };
}
