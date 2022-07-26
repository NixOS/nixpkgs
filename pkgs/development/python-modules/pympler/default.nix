{ lib, stdenv
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Pympler";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "993f1a3599ca3f4fcd7160c7545ad06310c9e12f70174ae7ae8d4e25f6c5d3fa";
  };

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # 'AssertionError: 'function (test.muppy.test_summary.func)' != 'function (muppy.test_summary.func)'
    # https://github.com/pympler/pympler/issues/134
    "test_repr_function"
  ];

  doCheck = stdenv.hostPlatform.isLinux;

  meta = with lib; {
    description = "Tool to measure, monitor and analyze memory behavior";
    homepage = "https://pythonhosted.org/Pympler/";
    license = licenses.asl20;
  };

}
