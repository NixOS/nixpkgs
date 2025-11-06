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
  version = "1.6.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kellyjonbrazil";
    repo = "jello";
    tag = "v${version}";
    hash = "sha256-RAQ04R1zDL9hk1q19GSFvdkxse5rJZXpboAondOoHEc=";
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
    changelog = "https://github.com/kellyjonbrazil/jello/blob/${src.tag}/CHANGELOG";
    license = licenses.mit;
    maintainers = [ ];
  };
}
