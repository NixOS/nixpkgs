{ lib, buildDotnetModule, fetchFromGitHub, dotnetCorePackages, SDL2, libsecret, glib, gnutls, aria2, steam, gst_all_1
, copyDesktopItems, makeDesktopItem, makeWrapper
, useSteamRun ? true
, useRbPatchedLauncher ? false }:

let
  goatcorp = {
    version = "1.0.8";
    owner = "goatcorp";
    rev = goatcorp.version;
    hash = "sha256-x4W5L4k+u0MYKDWJu82QcXARW0zjmqqwGiueR1IevMk=";
  };

  rankynbass = {
    version = "1.0.8.2";
    owner = "rankynbass";
    rev = "rb-v${rankynbass.version}";
    hash = "sha256-YU+oCBl+VnHZ5VanRECLTaCmj+0QaVF0lbzST9HikEs=";
  };

  source = if useRbPatchedLauncher then rankynbass else goatcorp;
in
  buildDotnetModule rec {
    pname = "XIVLauncher${lib.optionalString useRbPatchedLauncher "-rb"}";
    version = source.version;

    src = fetchFromGitHub {
      inherit (source) owner;
      repo = "XIVLauncher.Core";
      inherit (source) rev;
      inherit (source) hash;
      fetchSubmodules = true;
    };

    nativeBuildInputs = [ copyDesktopItems makeWrapper ];

    buildInputs = with gst_all_1; [ gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav ];

    projectFile = "src/XIVLauncher.Core/XIVLauncher.Core.csproj";
    nugetDeps = ./deps.nix; # File generated with `nix-build -A xivlauncher.passthru.fetch-deps`

    dotnetFlags = [
      "-p:BuildHash=${source.rev}"
      "-p:PublishSingleFile=false"
    ];

    postPatch = ''
      substituteInPlace lib/FFXIVQuickLauncher/src/XIVLauncher.Common/Game/Patch/Acquisition/Aria/AriaHttpPatchAcquisition.cs \
        --replace 'ariaPath = "aria2c"' 'ariaPath = "${aria2}/bin/aria2c"'
    '';

    postInstall = ''
      mkdir -p $out/share/pixmaps
      cp src/XIVLauncher.Core/Resources/logo.png $out/share/pixmaps/xivlauncher.png
    '';

    postFixup = lib.optionalString useSteamRun (let
      steam-run = (steam.override {
        extraPkgs = pkgs: [ pkgs.libunwind ];
        extraProfile = ''
          unset TZ
        '';
      }).run;
    in ''
      substituteInPlace $out/bin/XIVLauncher.Core \
        --replace 'exec' 'exec ${steam-run}/bin/steam-run'
    '') + ''
      wrapProgram $out/bin/XIVLauncher.Core --prefix GST_PLUGIN_SYSTEM_PATH_1_0 ":" "$GST_PLUGIN_SYSTEM_PATH_1_0"
      # the reference to aria2 gets mangled as UTF-16LE and isn't detectable by nix: https://github.com/NixOS/nixpkgs/issues/220065
      mkdir -p $out/nix-support
      echo ${aria2} >> $out/nix-support/depends
    '';

    executables = [ "XIVLauncher.Core" ];

    runtimeDeps = [ SDL2 libsecret glib gnutls ];

    desktopItems = [
      (makeDesktopItem {
        name = "xivlauncher";
        exec = "XIVLauncher.Core";
        icon = "xivlauncher";
        desktopName = "XIVLauncher${lib.optionalString useRbPatchedLauncher "-RB"}";
        comment = meta.description;
        categories = [ "Game" ];
        startupWMClass = "XIVLauncher.Core";
      })
    ];

    meta = with lib; {
      description = "Custom launcher for FFXIV";
      homepage = "https://github.com/${source.owner}/XIVLauncher.Core";
      license = licenses.gpl3;
      maintainers = with maintainers; [ sersorrel witchof0x20 ];
      platforms = [ "x86_64-linux" ];
      mainProgram = "XIVLauncher.Core";
    };
  }
