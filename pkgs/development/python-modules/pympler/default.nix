{ lib, stdenv
, bottle
, buildPythonPackage
, fetchpatch
, fetchPypi
, pytestCheckHook
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "Pympler";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "993f1a3599ca3f4fcd7160c7545ad06310c9e12f70174ae7ae8d4e25f6c5d3fa";
  };

  patches = [
    # Fixes a TypeError on Python 3.11
    # (see https://github.com/pympler/pympler/issues/148)
    # https://github.com/pympler/pympler/pull/149
    (fetchpatch {
      name = "${pname}-python-3.11-compat.patch";
      url = "https://github.com/pympler/pympler/commit/0fd8ad8da39207bd0dcb28bdac0407e04744c965.patch";
      hash = "sha256-6MK0AuhVhQkUzlk29HUh1+mSbfsVTBJ1YBtYNIFhh7U=";
    })
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # There is a version of bottle bundled with Pympler, but it is broken on
  # Python 3.11. Fortunately, Pympler will preferentially import an external
  # bottle if it is available, so we make it an explicit dependency.
  propagatedBuildInputs = [
    bottle
  ];

  disabledTests = [
    # 'AssertionError: 'function (test.muppy.test_summary.func)' != 'function (muppy.test_summary.func)'
    # https://github.com/pympler/pympler/issues/134
    "test_repr_function"
  ] ++ lib.optionals (pythonAtLeast "3.11") [
    # https://github.com/pympler/pympler/issues/148
    "test_findgarbage"
    "test_get_tree"
    "test_prune"
  ];

  doCheck = stdenv.hostPlatform.isLinux;

  meta = with lib; {
    description = "Tool to measure, monitor and analyze memory behavior";
    homepage = "https://pythonhosted.org/Pympler/";
    license = licenses.asl20;
  };

}
