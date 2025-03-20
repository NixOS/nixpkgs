{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pillow,
  zbar,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-zbar";
  version = "0.23.93";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mchehab";
    repo = "zbar";
    tag = version;
    hash = "sha256-6gOqMsmlYy6TK+iYPIBsCPAk8tYDliZYMYeTOidl4XQ=";
  };

  postPatch = ''
    cd python
  '';

  build-system = [ setuptools ];

  dependencies = [ pillow ];

  buildInputs = [ zbar ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    #AssertionError: b'Y800' != 'Y800'
    "test_format"
    "test_new"
    #Requires loading a recording device
    #zbar.SystemError: <zbar.Processor object at 0x7ffff615a680>
    "test_processing"
    # Version too long?
    # self.assertEqual(len(ver), 2)
    "test_version"
  ];

  pythonImportsCheck = [ "zbar" ];

  meta = with lib; {
    description = "Python bindings for zbar";
    homepage = "https://github.com/mchehab/zbar";
    license = licenses.lgpl21Only;
    maintainers = [ ];
  };
}
