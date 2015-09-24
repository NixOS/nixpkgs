# Maintainer's Notes:
#
# Minor updates:
#  1. Edit ./manifest.sh to point to the updated URL. Upstream sometimes
#     releases updates that include only the changed packages; in this case,
#     multiple URLs can be provided and the results will be merged.
#  2. Run ./manifest.sh and ./dependencies.sh.
#  3. Build and enjoy.
#
# Major updates:
#  We prefer not to immediately overwrite older versions with major updates, so
#  make a copy of this directory first. After copying, be sure to delete ./tmp
#  if it exists. Then follow the minor update instructions.

{ pkgs, newScope, qt5 ? null, debug ? false }:

let inherit (pkgs) autonix stdenv symlinkJoin; in

with autonix; let inherit (stdenv) lib; in

let
  qt5_ = if qt5 != null then qt5 else pkgs.qt54;
in

let

  qt5 = qt5_;

  super =
    let json = builtins.fromJSON (builtins.readFile ./packages.json);
        mirrorUrl = n: pkg: pkg // {
          src = pkg.src // { url = "mirror://kde/${pkg.src.url}"; };
        };
        renames = builtins.fromJSON (builtins.readFile ./renames.json);
        propagated = [ "extra-cmake-modules" ];
        native = [
          "bison"
          "extra-cmake-modules"
          "flex"
          "kdoctools"
          "ki18n"
          "libxslt"
          "perl"
          "pythoninterp"
        ];
        user = [
          "qt5"
          "qt5core"
          "qt5dbus"
          "qt5gui"
          "qt5qml"
          "qt5quick"
          "qt5svg"
          "qt5webkitwidgets"
          "qt5widgets"
          "qt5x11extras"
          "shareddesktopontologies"
          "sharedmimeinfo"
        ];
    in lib.fold (f: attrs: f attrs) json [
      (lib.mapAttrs kdePackage)
      (userEnvDeps user)
      (nativeDeps native)
      (propagateDeps propagated)
      (renameDeps renames)
      (lib.mapAttrs mirrorUrl)
    ];

  kdePackage = name: pkg:
    let defaultOverride = drv: drv // {
          setupHook = ./setup-hook.sh;
          cmakeFlags =
            (drv.cmakeFlags or [])
            ++ [ "-DBUILD_TESTING=OFF" ]
            ++ lib.optional debug "-DCMAKE_BUILD_TYPE=Debug";
          meta = {
            license = with stdenv.lib.licenses; [
              lgpl21Plus lgpl3Plus bsd2 mit gpl2Plus gpl3Plus fdl12
            ];
            platforms = stdenv.lib.platforms.linux;
            maintainers = with stdenv.lib.maintainers; [ ttuegel ];
            homepage = "http://www.kde.org";
          };
        };
        callPackage = newScope {
          inherit (stdenv) mkDerivation;
          inherit (pkgs) fetchurl;
          inherit scope;
        };
    in mkPackage callPackage defaultOverride name pkg;

  scope =
    # packages in this collection
    self //
    # packages pinned to this version of Qt 5
    {
      dbusmenu-qt5 = pkgs.libdbusmenu_qt5.override { inherit qt5; };
      phonon4qt5 = pkgs.phonon_qt5.override { inherit qt5; };
      polkit_qt5 = pkgs.polkit_qt5.override { inherit qt5; };
      qt5 = qt5.base;
      qt5core = qt5.base;
      qt5dbus = qt5.base;
      qt5gui = qt5.base;
      qt5linguisttools = qt5.tools;
      qt5qml = [qt5.declarative qt5.graphicaleffects];
      qt5quick = [qt5.quickcontrols qt5.graphicaleffects];
      qt5script = qt5.script;
      qt5svg = qt5.svg;
      qt5webkitwidgets = qt5.webkit;
      qt5widgets = qt5.base;
      qt5x11extras = qt5.x11extras;
      qt5xmlpatterns = qt5.xmlpatterns;
    } //
    # packages from the nixpkgs collection
    (with pkgs;
      {
        inherit acl cmake docbook_xml_dtd_45 docbook5_xsl epoxy fam gpgme
                libgcrypt libgit2 modemmanager networkmanager perl
                perlPackages qimageblitz xorg zlib;
        boost = boost155;
        gif = giflib;
        glib2 = glib;
        jpeg = libjpeg;
        libintl = gettext;
        liblzma = lzma;
        pythoninterp = python;
        pythonlibrary = python;
        sharedmimeinfo = shared_mime_info;
      }
    );

  self = super // {
    bluez-qt = overrideDerivation super.bluez-qt (drv: {
      preConfigure = ''
        substituteInPlace CMakeLists.txt \
          --replace /lib/udev/rules.d "$out/lib/udev/rules.d"
      '';
    });

    extra-cmake-modules = overrideDerivation super.extra-cmake-modules (drv: {
      buildInputs = [];
      nativeBuildInputs = [];
      propagatedBuildInputs = [];
      propagatedNativeBuildInputs = [ scope.cmake pkgs.pkgconfig qt5.tools ];
      propagatedUserEnvPkgs = [];
      cmakeFlags = ["-DBUILD_TESTING=OFF"];
      patches = [./extra-cmake-modules/0001-extra-cmake-modules-paths.patch];
      meta = {
        license = stdenv.lib.licenses.bsd2;
        platforms = stdenv.lib.platforms.linux;
        maintainers = with stdenv.lib.maintainers; [ ttuegel ];
        homepage = "http://www.kde.org";
      };
    });

    frameworkintegration = extendDerivation super.frameworkintegration {
      buildInputs = [ scope.xorg.libXcursor ];
    };

    kauth = extendDerivation super.kauth {
      buildInputs = [ scope.polkit_qt5 ];
      patches = [ ./kauth/kauth-policy-install.patch ];
    };

    kcmutils = extendDerivation super.kcmutils {
      patches = [ ./kcmutils/kcmutils-pluginselector-follow-symlinks.patch ];
    };

    kconfigwidgets = extendDerivation super.kconfigwidgets {
      patches = [ ./kconfigwidgets/kconfigwidgets-helpclient-follow-symlinks.patch ];
    };

    kdelibs4support = extendDerivation super.kdelibs4support {
      buildInputs = [ scope.networkmanager scope.xorg.libSM ];
      cmakeFlags = [
        "-DDocBookXML4_DTD_DIR=${pkgs.docbook_xml_dtd_45}/xml/dtd/docbook"
        "-DDocBookXML4_DTD_VERSION=4.5"
      ];
    };

    kdoctools = extendDerivation super.kdoctools {
      propagatedNativeBuildInputs = [ scope.perl scope.perlPackages.URI ];
      cmakeFlags = [
        "-DDocBookXML4_DTD_DIR=${scope.docbook_xml_dtd_45}/xml/dtd/docbook"
        "-DDocBookXML4_DTD_VERSION=4.5"
        "-DDocBookXSL_DIR=${scope.docbook5_xsl}/xml/xsl/docbook"
      ];
      patches = [ ./kdoctools/kdoctools-no-find-docbook-xml.patch ];
    };

    ki18n = extendDerivation super.ki18n {
      propagatedNativeBuildInputs = with scope; [ libintl pythoninterp ];
    };

    kimageformats = extendDerivation super.kimageformats {
      NIX_CFLAGS_COMPILE = "-I${pkgs.ilmbase}/include/OpenEXR";
    };

    kinit = extendDerivation super.kinit {
      patches = [./kinit/0001-kinit-libpath.patch];
    };

    kpackage = extendDerivation super.kpackage {
      patches = [ ./kpackage/0001-allow-external-paths.patch ];
    };

    kservice = extendDerivation super.kservice {
      buildInputs = [ scope.kwindowsystem ];
      patches = [
        ./kservice/kservice-kbuildsycoca-follow-symlinks.patch
        ./kservice/kservice-kbuildsycoca-no-canonicalize-path.patch
      ];
    };

    ktexteditor = extendDerivation super.ktexteditor {
      patches = [ ./ktexteditor/0001-no-qcoreapplication.patch ];
    };

    kwallet = extendDerivation super.kwallet {
      buildInputs = [ scope.kdoctools ];
    };

    networkmanager-qt = extendDerivation super.networkmanager-qt {
      propagatedBuildInputs = [ scope.networkmanager ];
    };
  };

in self
