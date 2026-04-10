{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "feedparser-sgmllib";
  version = "2.1.0";
  pyproject = true;
  src = fetchPypi {
    pname = "feedparser_sgmllib";
    inherit version;
    hash = "sha256-YfrPKRjEOJtbAHFPdsXgNDH/zZTNH1HWV+3WzXw5ZXk=";
  };
  build-system = [ poetry-core ];
  dependencies = [ ];

  doCheck = true;
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "feedparser_sgmllib" ];

  meta = {
    homepage = "https://pypi.org/project/feedparser-sgmllib/";
    changelog = "https://github.com/python-syndication/feedparser-sgmllib/releases/tag/v${version}";

    description = "Python 3 port of sgmllib designed for use with feedparser";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ ar4m1s ];
  };
}
