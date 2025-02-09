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
  version = "1.4.2";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+o6OF5nepUg85maUYmYPnZqVZJ9vmKgNMVuE7In0SfQ=";
  };

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = "pushd $out";
  postCheck = "popd";

  disabledTests = [ "test_make_c_files" ];

  pythonImportsCheck = [ "bottleneck" ];

  meta = with lib; {
    description = "Fast NumPy array functions";
    homepage = "https://github.com/pydata/bottleneck";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
