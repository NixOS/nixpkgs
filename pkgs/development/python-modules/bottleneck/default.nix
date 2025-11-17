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
  version = "1.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ao1G7ksCWtmrTXmSQROBb4JfYrF7h8nh0NjOFEpKDjE=";
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
