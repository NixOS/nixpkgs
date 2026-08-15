{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  installFonts,
}:

let
  pythonEnv =
    (python3.override {
      packageOverrides = self: super: {
        fonttools = super.fonttools.overridePythonAttrs (old: {
          propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.brotli ];
        });
      };
    }).withPackages
      (ps: [ ps.gftools ]);
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tiktok-sans";
  version = "4.000";

  outputs = [
    "out"
    "webfont"
  ];

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "tiktok";
    repo = "TikTokSans";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TT56I8G2yK6FEReNvpicwuanY25afvraIjydhbprA1c=";
  };

  nativeBuildInputs = [
    pythonEnv
    installFonts
  ];

  makeFlags = [ "build" ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "build.stamp: venv sources/config.yaml" "build.stamp: sources/config.yaml" \
      --replace-fail ". venv/bin/activate; " "" \
      --replace-fail "python3.10 " "python3 "
  '';

  # remove proprietary VTT-hinted font
  postBuild = ''
    rm -f sources/hinting/TikTok-VTT.ttf
  '';

  # skip default `make install`.
  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  meta = {
    homepage = "https://tiktok.com/font";
    changelog = "https://github.com/tiktok/TikTokSans/releases/tag/v${finalAttrs.version}";
    description = "A free and open-source font by TikTok";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ yarn ];
  };
})
