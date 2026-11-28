{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3Packages,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zhongdou-sans";
  version = "3.001";

  # New nixpkgs packages use structured derivation attributes for safer builds.
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "otakutyrant";
    repo = "Zhongdou-Sans";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0wk9OLPhlQbtFKPIWU3Pp/ursAyxvI7r5AzABG57LQs=";
  };

  strictDeps = true;

  nativeBuildInputs = [ python3Packages.fonttools ];

  buildPhase = ''
    runHook preBuild

    # Apply the project's reproducible transformations to its upstream font.
    python tools/build_font.py fonts/variable/ZhudouSansVF.ttf ZhongdouSansVF.ttf

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm444 ZhongdouSansVF.ttf \
      "$out/share/fonts/truetype/ZhongdouSansVF.ttf"

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    # Reuse the upstream structural checks against the installed font.
    python tools/check_release.py "v${finalAttrs.version}" \
      "$out/share/fonts/truetype/ZhongdouSansVF.ttf"

    runHook postInstallCheck
  '';

  meta = {
    description = "CJK punctuation font with centered Simplified Chinese punctuation";
    homepage = "https://github.com/otakutyrant/Zhongdou-Sans";
    license = lib.licenses.ofl;
    maintainers = [ lib.maintainers.otakutyrant ];
    platforms = lib.platforms.all;
  };
})
