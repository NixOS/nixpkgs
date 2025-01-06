{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  black,
}:

buildPythonPackage rec {
  pname = "black-macchiato";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "wbolster";
    repo = pname;
    rev = version;
    sha256 = "0lc9w50nlbmlzj44krk7kxcia202fhybbnwfh77xixlc7vb4rayl";
  };

  propagatedBuildInputs = [ black ];

  nativeCheckInputs = [
    pytestCheckHook
    black
  ];

  pythonImportsCheck = [ "black" ];

  meta = {
    description = "This is a small utility built on top of the black Python code formatter to enable formatting of partial files";
    mainProgram = "black-macchiato";
    homepage = "https://github.com/wbolster/black-macchiato";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jperras ];
  };
}
