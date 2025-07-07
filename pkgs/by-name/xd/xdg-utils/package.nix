{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitLab,
  runCommand,
  writeText,
  # docs deps
  libxslt,
  docbook_xml_dtd_412,
  docbook_xml_dtd_43,
  docbook_xsl,
  xmlto,
  # runtime deps
  resholve,
  bash,
  coreutils,
  dbus,
  file,
  gawk,
  glib,
  gnugrep,
  gnused,
  hostname-debian,
  jq,
  procps,
  which,
  xdg-user-dirs,
  shared-mime-info,
  perl,
  perlPackages,
  withXdgOpenUsePortalPatch ? true,
}:

let

  # Required by the common desktop detection code
  commonDeps = [
    dbus
    coreutils
    gnugrep
    gnused
  ];
  # These are all faked because the current desktop is detected
  # based on their presence, so we want them to be missing by default.
  commonFakes = [
    "explorer.exe"
    "gnome-default-applications-properties"
    "kde-config"
    "xprop"
  ];

  # This is still required to work around the eval trickery some scripts do
  commonPrologue = "${writeText "xdg-utils-prologue" ''
    export PATH=$PATH:${lib.makeBinPath [ coreutils ]}
  ''}";

  solutions = [
    {
      scripts = [ "bin/xdg-desktop-icon" ];
      interpreter = "${bash}/bin/bash";
      inputs = commonDeps ++ [ xdg-user-dirs ];
      execer = [
        "cannot:${xdg-user-dirs}/bin/xdg-user-dir"
      ];
      # These are desktop-specific, so we don't want xdg-utils to be able to
      # call them when in a different setup.
      fake.external = commonFakes ++ [
        "gconftool-2" # GNOME2
      ];
      keep."$KDE_SESSION_VERSION" = true;
      prologue = commonPrologue;
    }

    {
      scripts = [ "bin/xdg-desktop-menu" ];
      interpreter = "${bash}/bin/bash";
      inputs = commonDeps ++ [ gawk ];
      fake.external = commonFakes;
      keep."$KDE_SESSION_VERSION" = true;
      prologue = commonPrologue;
    }

    {
      scripts = [ "bin/xdg-email" ];
      interpreter = "${bash}/bin/bash";
      inputs = commonDeps ++ [
        gawk
        glib.bin
        "${placeholder "out"}/bin"
      ];
      execer = [
        "cannot:${placeholder "out"}/bin/xdg-mime"
        "cannot:${placeholder "out"}/bin/xdg-open"
      ];
      # These are desktop-specific, so we don't want xdg-utils to be able to
      # call them when in a different setup.
      fake.external = commonFakes ++ [
        "exo-open" # XFCE
        "gconftool-2" # GNOME
        "gio" # GNOME (new)
        "gnome-open" # GNOME (very old)
        "gvfs-open" # GNOME (old)
        "qtxdg-mat" # LXQT
        "xdg-email-hook.sh" # user-defined hook that may be available ambiently
      ];
      fix."/bin/echo" = true;
      keep = {
        "$command" = true;
        "$kreadconfig" = true;
        "$THUNDERBIRD" = true;
        "$utf8" = true;
      };
    }

    {
      scripts = [ "bin/xdg-icon-resource" ];
      interpreter = "${bash}/bin/bash";
      inputs = commonDeps;
      fake.external = commonFakes;
      keep."$KDE_SESSION_VERSION" = true;
      prologue = commonPrologue;
    }

    {
      scripts = [ "bin/xdg-mime" ];
      interpreter = "${bash}/bin/bash";
      inputs = commonDeps ++ [
        file
        gawk
      ];
      # These are desktop-specific, so we don't want xdg-utils to be able to
      # call them when in a different setup.
      fake.external = commonFakes ++ [
        "gio" # GNOME (new)
        "gnomevfs-info" # GNOME (very old)
        "gvfs-info" # GNOME (old)
        "kde4-config" # Plasma 4
        "kfile" # KDE 3
        "kmimetypefinder" # Plasma (generic)
        "kmimetypefinder5" # Plasma 5
        "ktraderclient" # KDE 3
        "ktradertest" # KDE 3
        "mimetype" # alternative tool for file, pulls in perl, avoid
        "qtpaths" # Plasma
        "qtxdg-mat" # LXQT
      ];
      fix."/usr/bin/file" = true;
      keep = {
        "$KDE_SESSION_VERSION" = true;
        "$KTRADER" = true;
      };
      prologue = "${writeText "xdg-mime-prologue" ''
        export XDG_DATA_DIRS="$XDG_DATA_DIRS''${XDG_DATA_DIRS:+:}${shared-mime-info}/share"
        export PERL5LIB=${with perlPackages; makePerlPath [ FileMimeInfo ]}
        export PATH=$PATH:${
          lib.makeBinPath [
            coreutils
            perlPackages.FileMimeInfo
          ]
        }
      ''}";
    }

    {
      scripts = [ "bin/xdg-open" ];
      interpreter = "${bash}/bin/bash";
      inputs = commonDeps ++ [
        hostname-debian
        glib.bin
        "${placeholder "out"}/bin"
      ];
      execer = [
        "cannot:${placeholder "out"}/bin/xdg-mime"
      ];
      # These are desktop-specific, so we don't want xdg-utils to be able to
      # call them when in a different setup.
      fake.external = commonFakes ++ [
        "cygstart" # Cygwin
        "dde-open" # Deepin
        "enlightenment_open" # Enlightenment
        "exo-open" # XFCE
        "gio" # GNOME (new)
        "gnome-open" # GNOME (very old)
        "gvfs-open" # GNOME (old)
        "kde-open" # Plasma
        "kfmclient" # KDE3
        "mate-open" # MATE
        "mimeopen" # alternative tool for file, pulls in perl, avoid
        "open" # macOS
        "pcmanfm" # LXDE
        "qtxdg-mat" # LXQT
        "run-mailcap" # generic
        "rundll32.exe" # WSL
        "wslpath" # WSL
      ];
      fix."$printf" = [ "printf" ];
      keep = {
        "env:$command" = true;
        "$browser" = true;
        "$KDE_SESSION_VERSION" = true;
      };
    }

    {
      scripts = [ "bin/xdg-screensaver" ];
      interpreter = "${bash}/bin/bash";
      inputs = commonDeps ++ [
        hostname-debian
        perl
        procps
      ];
      # These are desktop-specific, so we don't want xdg-utils to be able to
      # call them when in a different setup.
      fake.external = commonFakes ++ [
        "dcop" # KDE3
        "lockfile"
        "mate-screensaver-command" # MATE
        "xautolock" # Xautolock
        "xscreensaver-command" # Xscreensaver
        "xset" # generic-ish X
      ];
      keep = {
        "$MV" = true;
        "$XPROP" = true;
        "$lockfile_command" = true;
      };
      execer = [
        "cannot:${perl}/bin/perl"
      ];
      prologue = "${writeText "xdg-screensaver-prologue" ''
        export PERL5LIB=${
          with perlPackages;
          makePerlPath [
            NetDBus
            XMLTwig
            XMLParser
            X11Protocol
          ]
        }
        export PATH=$PATH:${coreutils}/bin
      ''}";
    }

    {
      scripts = [ "bin/xdg-settings" ];
      interpreter = "${bash}/bin/bash";
      inputs = commonDeps ++ [
        jq
        "${placeholder "out"}/bin"
      ];
      execer = [
        "cannot:${placeholder "out"}/bin/xdg-mime"
      ];
      # These are desktop-specific, so we don't want xdg-utils to be able to
      # call them when in a different setup.
      fake.external = commonFakes ++ [
        "gconftool-2" # GNOME
        "kreadconfig" # Plasma (generic)
        "kreadconfig5" # Plasma 5
        "kreadconfig6" # Plasma 6
        "ktradertest" # KDE3
        "kwriteconfig" # Plasma (generic)
        "kwriteconfig5" # Plasma 5
        "kwriteconfig6" # Plasma 6
        "qtxdg-mat" # LXQT
      ];
      keep = {
        "$KDE_SESSION_VERSION" = true;
        # get_browser_$handler
        "$handler" = true;
      };
    }

    {
      scripts = [ "bin/xdg-terminal" ];
      interpreter = "${bash}/bin/bash";
      inputs = commonDeps ++ [
        bash
        glib.bin
        which
      ];
      fake.external = commonFakes ++ [
        "gconftool-2" # GNOME
        "exo-open" # XFCE
        "lxterminal" # LXQT
        "qterminal" # LXQT
        "terminology" # Englightenment
      ];
      keep = {
        "$command" = true;
        "$kreadconfig" = true;
        "$terminal_exec" = true;
      };
      prologue = commonPrologue;
    }
  ];
in

stdenv.mkDerivation (self: {
  pname = "xdg-utils";
  version = "1.2.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xdg";
    repo = "xdg-utils";
    rev = "v${self.version}";
    hash = "sha256-58ElbrVlk+13DUODSEHBPcDDt9H+Kuee8Rz9CIcoy0I=";
  };

  patches = lib.optionals withXdgOpenUsePortalPatch [
    # Allow forcing the use of XDG portals using NIXOS_XDG_OPEN_USE_PORTAL environment variable.
    # Upstream PR: https://github.com/freedesktop/xdg-utils/pull/12
    ./allow-forcing-portal-use.patch
    #  Enable build of xdg-terminal
    ./enable-xdg-terminal.patch
  ];

  # just needed when built from git
  nativeBuildInputs = [
    libxslt
    docbook_xml_dtd_412
    docbook_xml_dtd_43
    docbook_xsl
    xmlto
  ];

  # explicitly provide a runtime shell so patchShebangs is consistent across build platforms
  buildInputs = [ bash ];

  preFixup = lib.concatStringsSep "\n" (
    map (resholve.phraseSolution "xdg-utils-resholved") solutions
  );

  passthru.tests.xdg-mime =
    runCommand "xdg-mime-test"
      {
        nativeBuildInputs = [ self.finalPackage ];
        preferLocalBuild = true;
        xenias = lib.mapAttrsToList (hash: urls: fetchurl { inherit hash urls; }) {
          "sha256-SL95tM1AjOi7vDnCyT10s0tvQvc+ZSZBbkNOYXfbOy0=" = [
            "https://static1.e621.net/data/0e/76/0e7672980d48e48c2d1373eb2505db5a.png"
          ];
          "sha256-Si9AtB7J9o6rK/oftv+saST77CNaeWomWU5ECfbRioM=" = [
            "https://static1.e621.net/data/25/3d/253dc77fbc60d7214bc60e4a647d1c32.jpg"
          ];
          "sha256-Z+onQRY5zlDWPp5/y4E6crLz3TaMCNipcxEEMSHuLkM=" = [
            "https://d.furaffinity.net/art/neotheta/1691409857/1691409857.neotheta_quickmakeanentry_by_neotheta-sig.png"
            "https://static1.e621.net/data/bf/e4/bfe43ba264ad68e5d8a101ecef69c03e.png"
          ];
        };
      }
      ''
        for x in $xenias; do
          ext=''${x##*.}
          type="$(xdg-mime query filetype $x)"
          [ $? -eq 0 ] && [ "$type" = "image/''${ext/jpg/jpeg}" ] || {
            echo "Incorrect MIME type '$type' for '$x'" >&2
            exit 1
          }
        done
        touch $out
      '';

  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/xdg-utils/";
    description = "Set of command line tools that assist applications with a variety of desktop integration tasks";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
})
