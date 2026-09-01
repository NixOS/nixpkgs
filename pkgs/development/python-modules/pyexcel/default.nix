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
  version = "0.7.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SJSD2MdnWk0E0KVaG13Qkldx4mYPpoEFyjQuSS9FnRs=";
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
