{ lib , buildPythonPackage , fetchFromGitHub , pillow , zbar , pytestCheckHook }:

buildPythonPackage rec {
  pname = "python-zbar";
  version = "0.23.90";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mchehab";
    repo = "zbar";
    rev = version;
    sha256 = "sha256-FvV7TMc4JbOiRjWLka0IhtpGGqGm5fis7h870OmJw2U=";
  };

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
