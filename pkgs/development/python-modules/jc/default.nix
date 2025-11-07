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
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "jc";
  version = "1.25.6";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kellyjonbrazil";
    repo = "jc";
    tag = "v${version}";
    hash = "sha256-nq5RyCnsWwFfnrlgmWEZg0gqTaJO9RBHTvtF7mBQ9i4=";
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

  meta = with lib; {
    description = "This tool serializes the output of popular command line tools and filetypes to structured JSON output";
    homepage = "https://github.com/kellyjonbrazil/jc";
    license = licenses.mit;
    maintainers = with maintainers; [ atemu ];
    changelog = "https://github.com/kellyjonbrazil/jc/blob/${src.tag}/CHANGELOG";
    mainProgram = "jc";
  };
}
