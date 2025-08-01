{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
  pyudev,
}:

buildPythonPackage rec {
  pname = "rtslib-fb";
  version = "2.2.2";
  pyproject = true;

  # TypeError: 'method' object does not support the context manager protocol
  postPatch = ''
    substituteInPlace rtslib/root.py \
      --replace-fail "Path(restore_file).open" "Path(restore_file).open('r')"
  '';

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "rtslib-fb";
    tag = "v${version}";
    hash = "sha256-FuXO/yGZBR+QRvB5s1tE77hjnisSfjjHSCPLvGJOYdM=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    pyudev
  ];

  postInstall = ''
    install -Dm555 scripts/targetctl -t $out/bin
  '';

  # No tests
  doCheck = false;

  meta = {
    description = "Python object API for managing the Linux LIO kernel target";
    homepage = "https://github.com/open-iscsi/rtslib-fb";
    changelog = "https://github.com/open-iscsi/rtslib-fb/releases/tag/v${version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "targetctl";
  };
}
