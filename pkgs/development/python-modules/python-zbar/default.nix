{ lib
, buildPythonPackage
, fetchFromGitHub
, pillow
, zbar
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-zbar";
  version = "0.23.93";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mchehab";
    repo = "zbar";
    rev = "refs/tags/${version}";
    hash = "sha256-6gOqMsmlYy6TK+iYPIBsCPAk8tYDliZYMYeTOidl4XQ=";
  };

  patches = [
    # python: enum: fix build for Python 3.11
    # https://github.com/mchehab/zbar/pull/231
    # the patch is reworked as it does not cleanly apply
    ./0001-python-enum-fix-build-for-Python-3.11.patch
  ];

  propagatedBuildInputs = [ pillow ];

  buildInputs = [ zbar ];

  nativeCheckInputs = [ pytestCheckHook ];

  preBuild = ''
    cd python
  '';

  disabledTests = [
    #AssertionError: b'Y800' != 'Y800'
    "test_format"
    "test_new"
    #Requires loading a recording device
    #zbar.SystemError: <zbar.Processor object at 0x7ffff615a680>
    "test_processing"
  ];

  pythonImportsCheck = [ "zbar" ];

  meta = with lib; {
    description = "Python bindings for zbar";
    homepage = "https://github.com/mchehab/zbar";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
