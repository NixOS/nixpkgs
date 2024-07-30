{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  installShellFiles,
  pygments,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "jello";
  version = "1.6.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kellyjonbrazil";
    repo = "jello";
    rev = "v${version}";
    hash = "sha256-EN09Kcnw4HNT2roCoQyZkoHEfkM9qxqtneZPuBg46z4=";
  };

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = [ pygments ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "jello" ];

  postInstall = ''
    installManPage man/jello.1
  '';

  meta = with lib; {
    description = "CLI tool to filter JSON and JSON Lines data with Python syntax";
    mainProgram = "jello";
    homepage = "https://github.com/kellyjonbrazil/jello";
    changelog = "https://github.com/kellyjonbrazil/jello/blob/${src.rev}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
