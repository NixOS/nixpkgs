{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pytest-mock
, pytestCheckHook
, pythonOlder
, glibcLocales
}:

buildPythonPackage rec {
  pname = "pyspnego";
  version = "0.1.6";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = pname;
    rev = "v${version}";
    sha256 = "0pfh2x0539f0k2qi2pbjm64b2fqp64c63xxpinvg1yfaw915kgpb";
  };

  propagatedBuildInputs = [
    cryptography
  ];

  checkInputs = [
    glibcLocales
    pytest-mock
    pytestCheckHook
  ];

  LC_ALL = "en_US.UTF-8";

  pythonImportsCheck = [ "spnego" ];

  meta = with lib; {
    description = "Python SPNEGO authentication library";
    homepage = "Python SPNEGO authentication library";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
