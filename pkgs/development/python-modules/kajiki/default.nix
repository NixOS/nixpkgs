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
  version = "0.9.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jackrosenthal";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-EbXe4Jh2IKAYw9GE0kFgKVv9c9uAOiFFYaMF8CGaOfg=";
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
    changelog = "https://github.com/jackrosenthal/kajiki/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
