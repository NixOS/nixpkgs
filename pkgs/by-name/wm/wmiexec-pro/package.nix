{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch2,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "wmiexec-pro";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "XiaoliChan";
    repo = "wmiexec-Pro";
    tag = "v${version}";
    hash = "sha256-jOqXIShd7Q5YZzF7woKdObtDJgeQgDeQXEPcHJJoT4Q=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    impacket
    numpy
    rich
  ];

  patches = [
    (fetchpatch2 {
      # https://github.com/XiaoliChan/wmiexec-Pro/pull/19
      url = "https://github.com/XiaoliChan/wmiexec-Pro/commit/e0f9b4afcf9f7532f536d4599a764a80f3656e99.patch";
      hash = "sha256-fjbCZvsHDiWSNaZnIqUMIhK2fG5XKxhJJQqFxLzjZQY=";
    })
  ];

  postInstall = ''
    mv $out/bin/wmiexec-pro{.py,}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "New generation of wmiexec.py with AV evasion features";
    homepage = "https://github.com/XiaoliChan/wmiexec-Pro";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ letgamer ];
    mainProgram = "wmiexec-pro";
  };
}
