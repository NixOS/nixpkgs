{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  hatchling,

  # native
  beets,

  # dependencies
  markdownify,
  natsort,
  tldextract,

  # passthru
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "beets-audible";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Neurrone";
    repo = "beets-audible";
    tag = "v${version}";
    hash = "sha256-uQNF04BK87vN5Ak3g05rS8+LQLxsNEncgz4oKhNidWI=";
  };

  build-system = [
    hatchling
  ];

  nativeBuildInputs = [
    beets
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
