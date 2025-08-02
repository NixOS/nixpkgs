{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  pytestCheckHook,
  python,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "bottleneck";
  version = "1.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yGAkLPIOadWqsuw8XWyMKhXxnkslsouPyiwqEs766dg=";
  };

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = "pushd $out";
  postCheck = "popd";

  disabledTests = [ "test_make_c_files" ];

  pythonImportsCheck = [ "bottleneck" ];

  meta = {
    description = "Fast NumPy array functions";
    homepage = "https://github.com/pydata/bottleneck";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
