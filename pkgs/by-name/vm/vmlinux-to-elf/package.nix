{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication {
  pname = "vmlinux-to-elf";
  version = "0-unstable-2024-07-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marin-m";
    repo = "vmlinux-to-elf";
    rev = "da14e789596d493f305688e221e9e34ebf63cbb8";
    hash = "sha256-GVoUIeJeLWCEFzrwiLX2h627ygQ7lX1qMp3hHT5O8O0=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    setuptools
    python-lzo
    zstandard
    lz4
  ];

  meta = {
    homepage = "https://github.com/marin-m/vmlinux-to-elf";
    description = "Converts a vmlinux/vmlinuz/bzImage/zImage kernel image to an ELF file";
    mainProgram = "vmlinux-to-elf";

    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.fidgetingbits ];
  };
}
