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

{ autonix, fetchurl, pkgs, qt5, stdenv, debug ? false }:

with stdenv.lib; with autonix;

let

  mkDerivation = drv:
    let inherit (builtins.parseDrvName drv.name) version; in
    stdenv.mkDerivation
      (drv // {
        setupHook = ./setup-hook.sh;

        enableParallelBuilding = drv.enableParallelBuilding or true;
        cmakeFlags =
          (drv.cmakeFlags or [])
          ++ [ "-DBUILD_TESTING=OFF"
            "-DKDE_DEFAULT_HOME=.kde5"
            "-DKDE4_DEFAULT_HOME=.kde"
          ]
          ++ optional debug "-DCMAKE_BUILD_TYPE=Debug";

        meta =
          {
            license = with stdenv.lib.licenses; [
              lgpl21Plus lgpl3Plus bsd2 mit gpl2Plus gpl3Plus fdl12
            ];
            platforms = stdenv.lib.platforms.linux;
            maintainers = with stdenv.lib.maintainers; [ ttuegel ];
            homepage = "http://www.kde.org";
            inherit version;
            branch = intersperse "." (take 2 (splitString "." version));
          } // (drv.meta or {});
      });

  renames = builtins.removeAttrs (import ./renames.nix {}) ["Backend" "CTest"];

  scope =
    # packages in this collection
    (mapAttrs (dep: name: kf5."${name}") renames) //
    # packages pinned to this version of Qt 5
    {
      Phonon4Qt5 = pkgs.phonon_qt5.override { inherit qt5; };
      Qt5 = qt5.base;
      Qt5Core = qt5.base;
      Qt5DBus = qt5.base;
      Qt5Gui = qt5.base;
      Qt5LinguistTools = qt5.tools;
      Qt5Qml = [qt5.declarative qt5.graphicaleffects];
      Qt5Quick = [qt5.quickcontrols qt5.graphicaleffects];
      Qt5Script = qt5.script;
      Qt5Svg = qt5.svg;
      Qt5WebkitWidgets = qt5.webkit;
      Qt5Widgets = qt5.base;
      Qt5X11Extras = qt5.x11extras;
      Qt5XmlPatterns = qt5.xmlpatterns;
      dbusmenu-qt5 = pkgs.libdbusmenu_qt5.override { inherit qt5; };
    } //
    # packages from the nixpkgs collection
    (with pkgs;
      {
        inherit cmake epoxy;
        Boost = boost155;
        GIF = giflib;
        GLIB2 = glib;
        Gpgme = gpgme;
        JPEG = libjpeg;
        LibGcrypt = libgcrypt;
        LibGit2 = libgit2;
        LibIntl = gettext;
        LibLZMA = lzma;
        NetworkManager = networkmanager;
        Perl = perl;
        PythonInterp = python;
        QImageBlitz = qimageblitz;
        SharedMimeInfo = shared_mime_info;
        ZLIB = zlib;
      }
    );

  mirror = "mirror://kde";

  preResolve = super:
    fold (f: x: f x) super
      [
        (userEnvPkg "SharedMimeInfo")
        (userEnvPkg "SharedDesktopOntologies")
      ];

  postResolve = super:
    super // {
      extra-cmake-modules = {
        inherit (super.extra-cmake-modules) name src;

        propagatedNativeBuildInputs = [ pkgs.cmake pkgs.pkgconfig qt5.tools ];
        cmakeFlags = ["-DBUILD_TESTING=OFF"];
        patches =
          [
            ./extra-cmake-modules/0001-extra-cmake-modules-paths.patch
          ];
        meta =
          let inherit (builtins.parseDrvName super.extra-cmake-modules.name) version; in
          {
            license = with stdenv.lib.licenses; [ bsd2 ];
            platforms = stdenv.lib.platforms.linux;
            maintainers = with stdenv.lib.maintainers; [ ttuegel ];
            homepage = "http://www.kde.org";
            inherit version;
            branch = intersperse "." (take 2 (splitString "." version));
          };
      };

      frameworkintegration = super.frameworkintegration // {
        buildInputs = with pkgs.xlibs; super.frameworkintegration.buildInputs ++ [ libXcursor ];
      };

      kauth = super.kauth // {
        buildInputs =
          super.kauth.buildInputs
          ++ [(pkgs.polkit_qt5.override { inherit qt5; })];
        patches = [./kauth/kauth-policy-install.patch];
      };

      kcmutils = super.kcmutils // {
        patches =
          [./kcmutils/kcmutils-pluginselector-follow-symlinks.patch];
      };

      kconfigwidgets = super.kconfigwidgets // {
        patches =
          [./kconfigwidgets/kconfigwidgets-helpclient-follow-symlinks.patch];
      };

      kdelibs4support = with pkgs; super.kdelibs4support // {
        buildInputs =
          super.kdelibs4support.buildInputs
          ++ [networkmanager xlibs.libSM];
        cmakeFlags =
          (super.kdelibs4support.cmakeFlags or [])
          ++ [
            "-DDocBookXML4_DTD_DIR=${docbook_xml_dtd_45}/xml/dtd/docbook"
            "-DDocBookXML4_DTD_VERSION=4.5"
          ];
      };

      kdoctools = with pkgs; super.kdoctools // {
        cmakeFlags =
          (super.kdoctools.cmakeFlags or [])
          ++ [
            "-DDocBookXML4_DTD_DIR=${docbook_xml_dtd_45}/xml/dtd/docbook"
            "-DDocBookXML4_DTD_VERSION=4.5"
            "-DDocBookXSL_DIR=${docbook5_xsl}/xml/xsl/docbook"
          ];
        patches = [./kdoctools/kdoctools-no-find-docbook-xml.patch];
      };

      ki18n = with pkgs; super.ki18n // {
        propagatedNativeBuildInputs =
          super.ki18n.propagatedNativeBuildInputs ++ [gettext python];
      };

      kimageformats = with pkgs; super.kimageformats // {
        NIX_CFLAGS_COMPILE =
          (super.kimageformats.NIX_CFLAGS_COMPILE or "")
          + " -I${ilmbase}/include/OpenEXR";
      };

      kinit = super.kinit // { patches = [ ./kinit/kinit-libpath.patch ]; };

      kpackage = super.kpackage // { patches = [ ./kpackage/0001-allow-external-paths.patch ]; };

      kservice = super.kservice // {
        buildInputs = super.kservice.buildInputs ++ [kf5.kwindowsystem];
        patches =
          [
            ./kservice/kservice-kbuildsycoca-follow-symlinks.patch
            ./kservice/kservice-kbuildsycoca-no-canonicalize-path.patch
          ];
      };

      ktexteditor = super.ktexteditor // {
        patches = [ ./ktexteditor/0001-no-qcoreapplication.patch ];
      };

    };

  kf5 = generateCollection ./. {
    inherit mirror mkDerivation preResolve postResolve renames scope;
  };

in

  kf5 // { inherit mkDerivation qt5 scope; }
