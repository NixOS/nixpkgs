{
  lib,
  stdenv,
  buildPackages,
  buildPythonPackage,
  fetchFromGitHub,
  installShellFiles,
  ruamel-yaml,
  xmltodict,
  pygments,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jc";
  version = "1.26.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kellyjonbrazil";
    repo = "jc";
    tag = "v${version}";
    hash = "sha256-y0N/8bX9huORpHmiQpOj73+UKyOE/irrVJstIodVVyU=";
  };

  propagatedBuildInputs = [
    ruamel-yaml
    xmltodict
    pygments
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd jc \
        --bash <(${emulator} $out/bin/jc --bash-comp) \
        --zsh  <(${emulator} $out/bin/jc --zsh-comp)
    '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jc" ];

  # tests require timezone to set America/Los_Angeles
  doCheck = false;

  meta = {
    description = "This tool serializes the output of popular command line tools and filetypes to structured JSON output";
    homepage = "https://github.com/kellyjonbrazil/jc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ atemu ];
    changelog = "https://github.com/kellyjonbrazil/jc/blob/${src.tag}/CHANGELOG";
    mainProgram = "jc";
  };
}
