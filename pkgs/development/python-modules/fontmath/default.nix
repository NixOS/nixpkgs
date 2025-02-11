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
  version = "0.9.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-H9kZDJ14ThMFw8SXcbkdkQ8kakt8RO3iGcmaB+167aQ=";
    extension = "zip";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ fonttools ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Collection of objects that implement fast font, glyph, etc. math";
    homepage = "https://github.com/robotools/fontMath/";
    changelog = "https://github.com/robotools/fontMath/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
