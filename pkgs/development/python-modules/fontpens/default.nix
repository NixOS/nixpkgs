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
    sha256 = "1za15dzsnymq6d9x7xdfqwgw4a3003wj75fn2crhyidkfd2s3nd6";
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
    description = "A collection of classes implementing the pen protocol for manipulating glyphs";
    homepage = "https://github.com/robotools/fontPens";
    license = licenses.bsd3;
    maintainers = [ maintainers.sternenseemann ];
  };
}
