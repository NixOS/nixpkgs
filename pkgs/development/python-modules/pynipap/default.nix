{
  lib,
  buildPythonPackage,
  nipap,

  # build deps
  setuptools,
}:

buildPythonPackage rec {
  pname = "pynipap";
  pyproject = true;

  inherit (nipap) version src;

  sourceRoot = "${src.name}/pynipap";

  build-system = [
    setuptools
  ];

  doCheck = false; # tests require nose, /etc/nipap/nipap.conf and a running nipapd

  meta = {
    description = "Python client library for Neat IP Address Planner";
    longDescription = ''
      NIPAP is the best open source IPAM in the known universe,
      challenging classical IP address management (IPAM) systems in many areas.
    '';
    homepage = "https://github.com/SpriteLink/NIPAP";
    changelog = "https://github.com/SpriteLink/NIPAP/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lukegb
    ];
    platforms = lib.platforms.all;
  };
}
