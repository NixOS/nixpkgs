{
  lib,
  buildPythonPackage,
  fetchPypi,
  pygments,
  dominate,
  beautifulsoup4,
  docutils,
  myst-parser,
  setuptools,
  sphinx,
}:

buildPythonPackage (finalAttrs: {
  pname = "alectryon";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "sha256-ouuCwipCQKSlH8NpF5QZd4jx4mEYooyIcnRhtDRWOnU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pygments
    dominate
    beautifulsoup4
    docutils
    myst-parser
    sphinx
  ];

  pythonImportsCheck = [ "alectryon" ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/cpitclaudel/alectryon";
    description = "Collection of tools for writing technical documents that mix Coq code and prose";
    mainProgram = "alectryon";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Zimmi48 ];
  };
})
