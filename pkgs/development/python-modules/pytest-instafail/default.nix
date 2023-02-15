{ buildPythonPackage
, fetchPypi
, lib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-instafail";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10lpr6mjcinabqynj6v85bvb1xmapnhqmg50nys1r6hg7zgky9qr";
  };

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "pytest_instafail" ];
  meta = {
    description = "pytest plugin that shows failures and errors instantly instead of waiting until the end of test session";
    homepage = "https://github.com/pytest-dev/pytest-instafail";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.jacg ];
  };
}
