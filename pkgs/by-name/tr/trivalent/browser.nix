{
  lib,
  fetchFromGitHub,
  chromium,
  libGL,
  vulkan-loader,
  pciutils,
}:

let
  version = "149.0.7827.114-445306";
  chromiumVersion = lib.head (lib.splitString "-" version);

  src = fetchFromGitHub {
    owner = "secureblue";
    repo = "Trivalent";
    tag = version;
    hash = "sha256-pWCSBb+OGk+xB9Z5VEkhmY4v1HrXU3js/40vbFp+hac=";
  };
in

chromium.mkDerivation (base: rec {
  name = "trivalent-browser";
  packageName = "trivalent";
  inherit version;

  buildTargets = [ "chrome" ];

  patches =
    # trivalent-etc-dir.patch already sets InitialPrefsPath, drop the conflicting one
    builtins.filter (p: baseNameOf p != "chromium-initial-prefs.patch") base.patches ++ [
      # Base only adds this for packageName == "chromium"
      ./widevine-disable-auto-download-allow-bundle.patch
    ];
  # trivalent.spec
  postPatch = ''
    for patchFile in ${src}/patches/third_party/vanadium/*.patch; do
      echo "applying Vanadium patch $patchFile"
      patch -p1 --fuzz=2 --no-backup-if-mismatch < "$patchFile"
    done

    while IFS= read -r patchFile; do
      echo "applying Trivalent patch $patchFile"
      patch -p1 --fuzz=2 --no-backup-if-mismatch < "$patchFile"
    done < <(find ${src}/patches/trivalent -name '*.patch' -printf '%f\t%p\n' | sort | cut -f2-)

    # Chrome/Chromium -> Trivalent string branding
    find . -type f \( -iname "*.grd" -o -iname "*.grdp" -o -iname "*.xtb" \) \
        ! -path "*ash_strings*" \
        ! -path "*android*" \
        ! -path "*chromeos_strings*" \
        ! -path "*ios/chrome*" \
        ! -path "*tools/grit/*" \
        ! -path "*device/fido/*" \
        ! -path "*chromeos/*" \
        ! -path "*remoting_strings*" \
        -exec sed -i \
            -e 's/\bph>Chromium<ph\b/REMOVE_PLACEHOLDER_CHROMIUM_PROJECT_TAG/g' \
            -e 's/\bGoogle Chrome\b/REMOVE_PLACEHOLDER_GOOGLE_CHROME/g' \
            -e 's/\Chrome Web Store\b/REMOVE_PLACEHOLDER_CHROME_WEB_STORE/g' \
            -e 's/\bThe Chromium Authors\b/REMOVE_PLACEHOLDER_THE_CHROMIUM_AUTHORS/g' \
            -e 's/\bChrom\(e\|ium\)\b/Trivalent/g' \
            -e 's/REMOVE_PLACEHOLDER_GOOGLE_CHROME/Google Chrome/g' \
            -e 's/REMOVE_PLACEHOLDER_CHROME_WEB_STORE/Chrome Web Store/g' \
            -e 's/REMOVE_PLACEHOLDER_THE_CHROMIUM_AUTHORS/The Chromium Authors/g' \
            -e 's/REMOVE_PLACEHOLDER_CHROMIUM_PROJECT_TAG/ph>Chromium<ph/g' {} +

    for size in 16 24 32 48 64 128 256; do
      cp ${src}/build/resources/trivalent$size.png \
        chrome/app/theme/chromium/product_logo_$size.png
    done
    for size in 24 48 64 128 256; do
      cp ${src}/build/resources/trivalent$size.png \
        chrome/app/theme/chromium/linux/product_logo_$size.png
    done
    for size in 16 32; do
      cp ${src}/build/resources/trivalent$size.png \
        chrome/app/theme/default_100_percent/chromium/product_logo_$size.png
      cp ${src}/build/resources/trivalent$size.png \
        chrome/app/theme/default_100_percent/chromium/linux/product_logo_$size.png
      cp ${src}/build/resources/trivalent$size.png \
        chrome/app/theme/default_200_percent/chromium/product_logo_$size.png
    done

    sed -i 's/getenv("CHROME_VERSION_EXTRA")/"trivalent"/' \
      chrome/common/channel_info_posix.cc
  ''
  + base.postPatch;

  # trivalent.spec
  gnFlags = {
    is_cfi = true;
    use_cfi_cast = true;

    enable_reporting = false;
    enable_remoting = false;
    enable_vr = false;

    use_webgpu_on_vulkan_via_gl_interop = false;

    use_static_angle = true;
    angle_shared_libvulkan = false;

    enable_swiftshader = false;
    enable_swiftshader_vulkan = false;
    dawn_use_swiftshader = false;
    angle_enable_swiftshader = false;

    build_dawn_tests = false;
    enable_perfetto_unittests = false;
    angle_has_histograms = false;
    safe_browsing_use_unrar = false;
    use_kerberos = true;
    rtc_link_pipewire = true;
    v8_enable_drumbrake = true;

    # Base only sets this for chromium, the CDM is added by the wrapper
    enable_widevine = true;

    google_api_key = "";
    enable_hangout_services_extension = false;
  };

  preBuild = (base.preBuild or "") + ''
    # CFI/ThinLTO link line is huge, raise the stack limit so ARG_MAX fits it
    ulimit -s 1048576
  '';

  installPhase = ''
    mkdir -p "$libExecPath"

    find "$buildPath" -maxdepth 1 -name '*.so' -exec cp -v {} "$libExecPath/" \;

    cp -v "$buildPath/"*.pak "$buildPath/"*.bin "$libExecPath/"
    cp -v "$buildPath/icudtl.dat" "$libExecPath/"
    cp -vLR "$buildPath/locales" "$buildPath/resources" "$libExecPath/"
    cp -v "$buildPath/chrome_crashpad_handler" "$libExecPath/"
    cp -v "$buildPath/chrome" "$libExecPath/$packageName"

    mkdir -vp "$out/share/man/man1"
    cp -v "$buildPath/chrome.1" "$out/share/man/man1/$packageName.1"

    for icon_file in chrome/app/theme/chromium/product_logo_*[0-9].png; do
      num_and_suffix="''${icon_file##*logo_}"
      icon_size="''${num_and_suffix%.*}"
      expr "$icon_size" : "^[0-9][0-9]*$" || continue
      logo_output_prefix="$out/share/icons/hicolor"
      logo_output_path="$logo_output_prefix/''${icon_size}x''${icon_size}/apps"
      mkdir -vp "$logo_output_path"
      cp -v "$icon_file" "$logo_output_path/$packageName.png"
    done

    install -Dm644 ${src}/build/install/trivalent.desktop \
      "$out/share/applications/trivalent.desktop"
    substituteInPlace "$out/share/applications/trivalent.desktop" \
      --replace-fail "Exec=/usr/bin/trivalent" "Exec=trivalent"

    # Strip the license comment before <?xml> that makes it invalid XML
    sed -n '/<?xml/,$p' ${src}/build/install/trivalent.appdata.xml > trivalent.appdata.xml
    install -Dm644 trivalent.appdata.xml "$out/share/metainfo/trivalent.appdata.xml"
  '';

  # Base postFixup patches libGLESv2.so and bundled libvulkan, neither exists here
  postFixup = ''
    patchelf --set-rpath "${
      lib.makeLibraryPath [
        libGL
        vulkan-loader
        pciutils
      ]
    }:$(patchelf --print-rpath "$libExecPath/$packageName")" "$libExecPath/$packageName"
  '';

  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    description = "Hardened Chromium build for desktop Linux, by secureblue";
    longDescription = ''
      Trivalent is a hardened Chromium fork by secureblue, inspired by
      GrapheneOS' Vanadium. It applies the Vanadium patch set (where
      applicable to desktop Linux) along with its own hardening and privacy
      patches on top of Chromium.
    '';
    homepage = "https://github.com/secureblue/Trivalent";
    changelog = "https://github.com/secureblue/Trivalent/releases/tag/${version}";
    license = with lib.licenses; [
      bsd3
      gpl2Only
      asl20
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "trivalent";
    maintainers = with lib.maintainers; [ aaravrav ];
    # Patch set is version-locked to Chromium
    broken = chromium.upstream-info.version != chromiumVersion;
    timeout = 172800; # 48h
  };
})
