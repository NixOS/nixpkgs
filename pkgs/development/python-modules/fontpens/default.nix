{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fonttools,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fontpens";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robotools";
    repo = "fontpens";
    tag = "v${version}";
    sha256 = "13msj0s7mg45klzbnd2w4f4ljb16bp9m0s872s6hczn0j7jmyz11";
  };

  build-system = [ setuptools ];

  dependencies = [ fonttools ];

  # can't run normal tests due to circular dependency with fontParts
  doCheck = false;
  pythonImportsCheck = [
    "fontPens"
  ]
  ++ (map (s: "fontPens." + s) [
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
