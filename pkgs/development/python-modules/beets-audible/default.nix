{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  uv-build,

  # native
  beets-minimal,

  # dependencies
  markdownify,
  natsort,
  tldextract,

  # passthru
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "beets-audible";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Neurrone";
    repo = "beets-audible";
    tag = "v${version}";
    hash = "sha256-JijKKbceQejpOFIjrpoWRt6qlwBA6Yr8dwVTHyM7Io8=";
  };

  build-system = [
    uv-build
  ];

  nativeBuildInputs = [
    beets-minimal
  ];

  pythonRelaxDeps = true;

  dependencies = [
    markdownify
    natsort
    tldextract
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Beets-audible: Organize Your Audiobook Collection With Beets";
    homepage = "https://github.com/Neurrone/beets-audible";
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ jwillikers ];
  };
}
