{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  cppy,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "atom";
  version = "0.12.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nucleic";
    repo = "atom";
    tag = version;
    hash = "sha256-XFJujJrxubtdCLTr1oaM7h0LNS1Ep08f8+1tRzARBqs=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ cppy ];

  preCheck = ''
    rm -rf atom
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "atom.api" ];

  meta = with lib; {
    description = "Memory efficient Python objects";
    homepage = "https://github.com/nucleic/atom";
    changelog = "https://github.com/nucleic/atom/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bhipple ];
  };
}
