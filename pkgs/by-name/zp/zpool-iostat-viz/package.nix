{
  lib,
  fetchFromGitHub,
  python3Packages,
  installShellFiles,
}:

python3Packages.buildPythonApplication {
  pname = "zpool-iostat-viz";
  version = "unstable-2021-11-13";
  format = "other";

  src = fetchFromGitHub {
    owner = "chadmiller";
    repo = "zpool-iostat-viz";
    rev = "cdd8f3d882ab7a9990fb2d26af3e5b2bcc4bb312";
    sha256 = "sha256-vNXD5SauBpCtP7VPTumQ0/wXfW0PjtooS21cjpAole8=";
  };

  nativeBuildInputs = [
    installShellFiles
    python3Packages.wrapPython
  ];

  # There is no setup.py
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;

  installPhase = ''
    wrapPythonPrograms
    install -D zpool-iostat-viz $out/bin/zpool-iostat-viz
    installManPage zpool-iostat-viz.1
  '';

  meta = with lib; {
    description = "\"zpool iostats\" for humans; find the slow parts of your ZFS pool";
    homepage = "https://github.com/chadmiller/zpool-iostat-viz";
    license = licenses.bsd2;
    maintainers = with maintainers; [ julm ];
    mainProgram = "zpool-iostat-viz";
  };
}
