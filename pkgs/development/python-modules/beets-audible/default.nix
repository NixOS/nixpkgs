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
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Neurrone";
    repo = "beets-audible";
    tag = "v${version}";
    hash = "sha256-u4EbUmUsaCs22QBGaKWzPjz0nzxH/zQBIQ8vsyVHBoE=";
  };

  # https://github.com/Neurrone/beets-audible/issues/87
  preBuild = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.10.0,<0.11.0" "uv_build>=0.10.0"
  '';

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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jwillikers ];
  };
}
