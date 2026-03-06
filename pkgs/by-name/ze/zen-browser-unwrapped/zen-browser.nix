{
  branding ? "release",
  fetchFromGitHub,
  fetchurl,
  rsync,
  rustPlatform,
  writeText,
}:
let
  assets = import ./assets.nix { inherit branding surfer-config writeText; };

  ffprefs = rustPlatform.buildRustPackage {
    cargoHash = "sha256-DZMwxeulQiIiSATU0MoyqiUMA0USZq6umhkr67hZH1Q=";
    pname = "ffprefs";
    postPatch = ''
      substituteInPlace src/main.rs \
        --replace-fail "../engine/" "../"
    '';
    src = "${zen-src}/tools/ffprefs";
    version = zen-version;
  };

  firefox-src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${firefox-version}/source/firefox-${firefox-version}.source.tar.xz";
    hash = "sha512-zdhxp3OPtw2FpwPonEh00b9EGEtMmyiQGQKty/olwZlnXnRjBrtZ1mgh5uzRfgfJm2akjYJ/OazKbDsBK5U3Gg==";
  };

  firefox-version = "149.0";

  surfer-config = {
    name = "Zen Browser";
    vendor = "Zen OSS Team";
    appId = "zen";
    brands = {
      release = {
        backgroundColor = "#282A33";
        brandShorterName = "Zen";
        brandShortName = "Zen";
        brandFullName = "Zen Browser";
      };
      twilight = {
        backgroundColor = "#282A33";
        brandShorterName = "Zen";
        brandShortName = "Twilight";
        brandFullName = "Zen Twilight";
      };
    };
  };

  zen-src = fetchFromGitHub {
    owner = "zen-browser";
    repo = "desktop";
    tag = zen-version;
    hash = "sha256-UQATOPDahwaxoWQcawnT/d5go6YJPjIVud9Bow8BfRg=";
  };

  zen-version = "1.19.5b";
in
{
  inherit
    ffprefs
    firefox-src
    firefox-version
    zen-version
    ;

  extraNativeBuildInputs = [
    rsync
  ];

  extraPostPatch = ''
    rsync -r ${zen-src}/prefs/ prefs
    ${ffprefs}/bin/ffprefs .

    rsync -r --exclude "*.patch" "${zen-src}/src/" .

    find "${zen-src}/src" -type f -name "*.patch" ! -name "fix_macos_crash_on_shutdown_firefox_149.patch" | while read -r patch_name; do
      patch -p1 < $patch_name
    done

    rsync -r "${zen-src}/locales/en-US/browser/" browser/locales/en-US/
    for language in $(cat ${zen-src}/locales/supported-languages); do
      loc="$(grep -m1 "^$language:" "${zen-src}/locales/language-maps" | cut -d: -f2 || true)"
      loc="''${loc:-$language}"
      rsync -r "${zen-src}/locales/$language/." browser/locales/$loc
    done

    rsync -r --exclude='branding.nsi' browser/branding/unofficial/. browser/branding/${branding}

    cp -r ${zen-src}/configs/branding/${branding} browser/branding
    for size in 16 22 24 32 48 64 128 256 512; do
      cp ${zen-src}/configs/branding/${branding}/logo"$size".png browser/branding/${branding}/default"$size".png
    done

    rsync ${assets.brandDtd} browser/branding/${branding}/locales/en-US/brand.dtd
    rsync ${assets.brandFtl} browser/branding/${branding}/locales/en-US/brand.ftl
    rsync ${assets.brandProperties} browser/branding/${branding}/locales/en-US/brand.properties
    rsync ${assets.brandingNsi} browser/branding/${branding}/branding.nsi
    rsync ${assets.configureSh} browser/branding/${branding}/configure.sh
    rsync ${assets.firefox-brandingJs} browser/branding/${branding}/pref/firefox-branding.js

    find "browser/branding/${branding}" -type f -name "*.css" | while read -r style; do
      echo ":root { --theme-bg: ${surfer-config.brands.${branding}.backgroundColor} }" >> $style
      sed -i -E 's/#130829|hsla\(235, 43%, 10%, 0\.5\)/var(--theme-bg)/g' $style
    done

    substituteInPlace build/application.ini.in \
      --replace-fail 'URL=https://@MOZ_APPUPDATE_HOST@/update/6/%PRODUCT%/%VERSION%/%BUILD_ID%/%BUILD_TARGET%/%LOCALE%/%CHANNEL%/%OS_VERSION%/%SYSTEM_CAPABILITIES%/%DISTRIBUTION%/%DISTRIBUTION_VERSION%/update.xml' 'URL=https://@MOZ_APPUPDATE_HOST@/updates/browser/%BUILD_TARGET%/%CHANNEL%/update.xml'

    substituteInPlace browser/installer/windows/nsis/shared.nsh  \
      --replace-fail '"Publisher" "Mozilla"' '"Publisher" "${surfer-config.vendor}"'

    scripts="$(mktemp -d)"
    cp -r "${zen-src}/scripts/." "$scripts"
    sed -i '9,15c\
    DUMPS_FOLDER = "${zen-src}/configs/dumps"\
    ENGINE_DUMPS_FOLDER = "services/settings/dumps/main"' $scripts/update_service_dumps.py

    python $scripts/update_service_dumps.py

    for file in browser/config/version.txt browser/config/version_display.txt; do
      echo "${zen-version}" > $file
    done
  '';
}
