{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  beautifulsoup4,
  dataproperty,
  excelrd,
  jsonschema,
  markdown,
  mbstrdecoder,
  path,
  pathvalidate,
  retryrequests,
  simplesqlite,
  tabledata,
  typepy,
}:

buildPythonPackage rec {
  pname = "pytablereader";
  version = "0.31.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "pytablereader";
    tag = "v${version}";
    hash = "sha256-SxYP6JT7r9udUFh6ZADvKmMMnvFcStFx8qelK8pmsZ0=";
  };

  build-system = [ setuptools ];

  postPatch = ''
    substituteInPlace requirements/requirements.txt \
      --replace-fail "path>=13,<17" "path>=13"
  '';

  dependencies = [
    beautifulsoup4
    dataproperty
    jsonschema
    mbstrdecoder
    path
    pathvalidate
    tabledata
    typepy
  ];

  optional-dependencies = {
    excel = [ excelrd ];
    md = [ markdown ];
    sqlite = [ simplesqlite ];
    url = [ retryrequests ];
  };

  pythonImportsCheck = [ "pytablereader" ];

  meta = {
    description = "Python library to load tabular data from various data formats";
    homepage = "https://github.com/thombashi/pytablereader";
    changelog = "https://github.com/thombashi/pytablereader/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
