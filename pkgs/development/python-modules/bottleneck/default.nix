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
  version = "1.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vrNt9Rm4cJ59NXwMljmwO4hcpjVbv15TdSxoXeUWBbg=";
  };

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "$out/${python.sitePackages}" ];

  disabledTests = [ "test_make_c_files" ];

  pythonImportsCheck = [ "bottleneck" ];

  meta = with lib; {
    description = "Fast NumPy array functions";
    homepage = "https://github.com/pydata/bottleneck";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
