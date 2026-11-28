{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "wmiexec-pro";
  version = "0.4.1-unstable-2026-03-24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "XiaoliChan";
    repo = "wmiexec-Pro";
    rev = "eeb3afc6bd9b7caadc7dc0adfcb53ef79ff555f4";
    hash = "sha256-j4azC3iJp7GHi0GDS8fO6NnOcNvQutKlKyOnbhMyb5U=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    impacket
    numpy
    rich
  ];

  postInstall = ''
    mv $out/bin/wmiexec-pro{.py,}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "New generation of wmiexec.py with AV evasion features";
    homepage = "https://github.com/XiaoliChan/wmiexec-Pro";
    changelog = "https://github.com/XiaoliChan/wmiexec-Pro/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ letgamer ];
    mainProgram = "wmiexec-pro";
  };
})
