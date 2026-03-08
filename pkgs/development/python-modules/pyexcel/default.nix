{
  lib,
  buildPythonPackage,
  chardet,
  fetchPypi,
  lml,
  pyexcel-io,
  setuptools,
  texttable,
}:

buildPythonPackage rec {
  pname = "pyexcel";
  version = "0.7.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-y73GBTK7sqIv5DA+gkqqOG7PbcUU0fh9GtA6E4X+5L0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    chardet
    lml
    pyexcel-io
    texttable
  ];

  pythonImportsCheck = [ "pyexcel" ];

  # Tests depend on pyexcel-xls & co. causing circular dependency.
  # https://github.com/pyexcel/pyexcel/blob/dev/tests/requirements.txt
  doCheck = false;

  meta = {
    description = "Single API for reading, manipulating and writing data in csv, ods, xls, xlsx and xlsm files";
    homepage = "http://docs.pyexcel.org/";
    changelog = "https://github.com/pyexcel/pyexcel/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
