{
  fetchFromGitHub,
  lib,
  python3,
  unstableGitUpdater,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "vmlinux-to-elf";
  version = "0-unstable-2024-07-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marin-m";
    repo = "vmlinux-to-elf";
    rev = "da14e789596d493f305688e221e9e34ebf63cbb8";
    hash = "sha256-GVoUIeJeLWCEFzrwiLX2h627ygQ7lX1qMp3hHT5O8O0=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = [
    python3.pkgs.lz4
    python3.pkgs.python-lzo
    python3.pkgs.zstandard
  ];

  pythonImportsCheck = [ "vmlinux_to_elf" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Tool to recover a fully analyzable .ELF from a raw kernel, through extracting the kernel symbol table";
    homepage = "https://github.com/marin-m/vmlinux-to-elf";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ KSJ2000 ];
    mainProgram = "vmlinux-to-elf";
  };
}
