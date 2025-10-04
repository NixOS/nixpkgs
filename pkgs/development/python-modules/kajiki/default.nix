{
  lib,
  babel,
  buildPythonPackage,
  fetchFromGitHub,
  linetable,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "kajiki";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jackrosenthal";
    repo = "kajiki";
    tag = "v${version}";
    hash = "sha256-5qsRxKeWCndi2r1HaIX/bm92oOWU4J4eM9aud6ai8ZQ=";
  };

  propagatedBuildInputs = [ linetable ];

  nativeCheckInputs = [
    babel
    pytestCheckHook
  ];

  pythonImportsCheck = [ "kajiki" ];

  meta = with lib; {
    description = "Module provides fast well-formed XML templates";
    mainProgram = "kajiki";
    homepage = "https://github.com/nandoflorestan/kajiki";
    changelog = "https://github.com/jackrosenthal/kajiki/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
