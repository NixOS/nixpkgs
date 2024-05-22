{
  lib,
  buildPythonPackage,
  fetchPypi,
  fonttools,
  setuptools-scm,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "fontmath";
  version = "0.9.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "fontMath";
    inherit version;
    hash = "sha256-alOHy3/rEFlY2y9c7tyHhRPMNb83FeJiCQ8FV74MGxw=";
    extension = "zip";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ fonttools ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A collection of objects that implement fast font, glyph, etc. math";
    homepage = "https://github.com/robotools/fontMath/";
    changelog = "https://github.com/robotools/fontMath/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
