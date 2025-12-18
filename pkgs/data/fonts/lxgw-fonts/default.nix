{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
}:

let
  makeLxgwFont =
    name:
    {
      version,
      hash,
      baseUrl ? "",
      repoName,
      fontName,
      description,
      license,
    }:
    stdenvNoCC.mkDerivation {
      inherit version;
      pname = "lxgw-${name}";

      src = fetchurl {
        inherit hash;
        url =
          if baseUrl == "" then
            "https://github.com/lxgw/${repoName}/releases/download/v${version}/${fontName}.ttf"
          else
            "${baseUrl}/${fontName}.ttf";
      };

      dontUnpack = true;

      installPhase = ''
        runHook preInstall

        install -Dm644 "$src" "$out/share/fonts/truetype/${fontName}.ttf"

        runHook postInstall
      '';

      passthru.updateScript = nix-update-script { };

      meta = {
        inherit description license;
        homepage = "https://github.com/lxgw/${repoName}";
        platforms = lib.platforms.all;
        maintainers = with lib.maintainers; [ chillcicada ];
      };
    };

  fonts = rec {
    wenkai = {
      version = "1.521";
      hash = "sha256-tkt63Sl2cr8ExUziKWeN3wm0+Wccsezh8kyGj0Im7dA=";
      repoName = "LXGWWenKai";
      fontName = "LXGWWenKai-Regular";
      description = "Open-source Chinese font derived from Fontworks' Klee One";
      license = lib.licenses.ofl;
    };

    wenkai-light = wenkai // {
      fontName = "LXGWWenKai-Light";
      hash = "sha256-UFn7Z6gfUhJ4naLW1m/FeLebmDfa0IJroQLYkvI/4TM=";
    };

    wenkai-medium = wenkai // {
      fontName = "LXGWWenKai-Medium";
      hash = "sha256-G3RmczNhLrBbehpwqbMkRYJRzYHpodbBv9ItqHFzS5w=";
    };

    wenkai-mono = wenkai // {
      fontName = "LXGWWenKaiMono-Regular";
      hash = "sha256-zZV/hwFJ0fp8EIC9B5QY/p1dYImTFtoeEtcwLnae074=";
    };

    wenkai-mono-light = wenkai // {
      fontName = "LXGWWenKaiMono-Light";
      hash = "sha256-6fuUp7OUDavODqm8emzPCOmId6BULpWmtIKUN/HurHI=";
    };

    wenkai-mono-medium = wenkai // {
      fontName = "LXGWWenKaiMono-Medium";
      hash = "sha256-Kl5cCdZSJa1mGcf0eZ2CSwDDI5khueRCRcB5rQeUGzM=";
    };

    wenkai-gb = {
      version = "1.521";
      hash = "sha256-ira49IvHk9Z1v6iiTGrVGMkVetECL+x+AV/ecY3ueA8=";
      repoName = "LxgwWenKaiGB";
      fontName = "LXGWWenKaiGB-Regular";
      description = "Open-source Simplified Chinese font derived from Klee One";
      license = lib.licenses.ofl;
    };

    wenkai-gb-light = wenkai-gb // {
      fontName = "LXGWWenKaiGB-Light";
      hash = "sha256-yseWgBhVsIidmZZK4UCoAluG0oNgzPVdP4fy4lysItY=";
    };

    wenkai-gb-medium = wenkai-gb // {
      fontName = "LXGWWenKaiGB-Medium";
      hash = "sha256-wjF2pGH2XXGnKu0y7YyjLynrt/iuQ8DKPD8Igw3mGAs=";
    };

    wenkai-mono-gb = wenkai-gb // {
      fontName = "LXGWWenKaiMonoGB-Regular";
      hash = "sha256-QWYLMJ5CdX6j51fPNYvpJsNoXj4vP1Nv/vKZACqh4QU=";
    };

    wenkai-mono-gb-light = wenkai-gb // {
      fontName = "LXGWWenKaiMonoGB-Light";
      hash = "sha256-/tVKvhzOJEL5DmnG0TesWoQAoF8z6o0+UYrz0HP4LKg=";
    };

    wenkai-mono-gb-medium = wenkai-gb // {
      fontName = "LXGWWenKaiMonoGB-Medium";
      hash = "sha256-rs4byR3zWRtu2ad1h7IP/jgii5EUoaTlQgfVD2gC6D4=";
    };

    wenkai-tc = {
      version = "1.521";
      hash = "sha256-DqU8ENFYkjatlueVk1PrtstNldbz6zpK8yDBzRtoLxE=";
      repoName = "LxgwWenKaiTC";
      fontName = "LXGWWenKaiTC-Regular";
      description = "Traditional Chinese Edition of LXGW WenKai";
      license = lib.licenses.ofl;
    };

    wenkai-tc-light = wenkai-tc // {
      fontName = "LXGWWenKaiTC-Light";
      hash = "sha256-sCqt5FGR9FOus7NbSR8NdyDce4pKJ2vcbltjZHHP64s=";
    };

    wenkai-tc-medium = wenkai-tc // {
      fontName = "LXGWWenKaiTC-Medium";
      hash = "sha256-LYQ3cPuifyMUuSWC4bLdOCqoKXmo2yldzWT+dT9IP4s=";
    };

    wenkai-mono-tc = wenkai-tc // {
      fontName = "LXGWWenKaiMonoTC-Regular";
      hash = "sha256-cq/PYx8tB6uHBwqyDqNidjmR+PZqVQW/q1Q33Ink/Hc=";
    };

    wenkai-mono-tc-light = wenkai-tc // {
      fontName = "LXGWWenKaiMonoTC-Light";
      hash = "sha256-0xpnsI/nej6twyilqcNMGkxshlPjzdIZ87eeWnWScRw=";
    };

    wenkai-mono-tc-medium = wenkai-tc // {
      fontName = "LXGWWenKaiMonoTC-Medium";
      hash = "sha256-M6E2aebZfObFrzyGIyZaofzPjkQ9mHldxLI+rT12L3I=";
    };

    wenkai-screen = {
      version = "1.521";
      hash = "sha256-7tqMMmIOmMHJHdGXrdD0glguDTJvx+vKYnPDda9OdBk=";
      repoName = "LxgwWenKai-Screen";
      fontName = "LXGWWenKaiScreen";
      description = "LXGW WenKai for Screen Reading";
      license = lib.licenses.ofl;
    };

    wenkai-gb-screen = wenkai-screen // {
      fontName = "LXGWWenKaiGBScreen";
      hash = "sha256-AKjaLo0uJusj2dFYh9WPvPZvYOxp65KzElQftLp9pHU=";
    };

    wenkai-mono-screen = wenkai-screen // {
      fontName = "LXGWWenKaiMonoScreen";
      hash = "sha256-LIuFLFJyHwYzWaBFTWqvQ/G4QaBwxWMmiHR07AqCvPE=";
    };

    wenkai-mono-gb-screen = wenkai-screen // {
      fontName = "LXGWWenKaiMonoGBScreen";
      hash = "sha256-YfWBs+1H8NdTdCFjXcW65kUUfODXUt567XeNVBjlAso=";
    };

    bright = rec {
      version = "5.527";
      hash = "sha256-LLh/Tn+nsBbnxsAyXODRpme+/ZbF4bWd4JXsO4i7E1Q=";
      baseUrl = "https://raw.githubusercontent.com/lxgw/LxgwBright/refs/tags/v${version}/LXGWBright";
      repoName = "LxgwBright";
      fontName = "LXGWBright-Regular";
      description = "Merged font of Ysabeau and LXGW WenKai";
      license = lib.licenses.ofl;
    };

    neoxihei = {
      version = "1.228";
      hash = "sha256-1RCcvlgbOE06DIgBALq2PJxipGVFonhQJcFr03dOEzc=";
      repoName = "LxgwNeoXiHei";
      fontName = "LXGWNeoXiHei";
      description = "Chinese sans-serif font derived from IPAex Gothic";
      license = lib.licenses.ipa;
    };

    neoxihei-plus = neoxihei // {
      fontName = "LXGWNeoXiHeiPlus";
      hash = "sha256-4E/ymiS7HaQgY/6bu6X6Juo4wmZpv288ecok6vrw6ho=";
    };

    neozhisong = {
      version = "1.055";
      hash = "sha256-Enc/WXnHyDS3Gkdb0vEduieR3eJGmpbubebEbu3EyLs=";
      repoName = "LxgwNeoZhiSong";
      fontName = "LXGWNeoZhiSong";
      description = "Chinese serif font derived from IPAmj Mincho";
      license = lib.licenses.ipa;
    };

    neozhisong-plus = neozhisong // {
      fontName = "LXGWNeoZhiSongPlus";
      hash = "sha256-DyrjC9XCwrfCilJ+5OnkzoOk1Iu5CcBm45/idIRb3IE=";
    };

    neoxihei-screen = rec {
      version = "25.12.15";
      hash = "sha256-KCgWYnV9OO3uZvUAvl4AzMjInUg9iPoiGTXrc6gRsIs=";
      baseUrl = "https://github.com/lxgw/LxgwNeoXiZhi-Screen/releases/download/${version}";
      repoName = "LxgwNeoXiZhi-Screen";
      fontName = "LXGWNeoXiHeiScreen";
      description = "LXGW Neo XiHei for screen reading";
      license = lib.licenses.ipa;
    };

    neoxihei-screen-full = neoxihei-screen // {
      fontName = "LXGWNeoXiHeiScreen-Full";
      hash = "sha256-rXYBrLAnxlEYRChMNvT/7Edy2tSGyHOKPNgKGHIoiPU=";
      description = "LXGW Neo XiHei for screen reading with full character set";
    };

    neozhisong-screen = neoxihei-screen // {
      fontName = "LXGWNeoZhiSongScreen";
      hash = "sha256-bDftpGKoZP50DbfAxFS2wHvDBla9WEVlyWCCvuVzOus=";
      description = "LXGW Neo ZhiSong for screen reading";
    };

    neozhisong-screen-full = neoxihei-screen // {
      fontName = "LXGWNeoZhiSongScreen-Full";
      hash = "sha256-n8oNEo14CtIBsudQ1y7+jNx/kX/jh5ywLZb3JVfA+ZY=";
      description = "LXGW Neo ZhiSong for screen reading with full character set";
    };
  };
in

lib.mapAttrs makeLxgwFont fonts
