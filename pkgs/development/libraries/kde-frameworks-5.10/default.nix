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

{ autonix, fetchurl, pkgs, qt5, stdenv, newScope, debug ? false }:

with autonix;

let inherit (stdenv) lib; in

let

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
      dbusmenu-qt5 = pkgs.libdbusmenu_qt5.override { inherit qt5; };
    } //
    # packages from the nixpkgs collection
    (with pkgs;
      {
        inherit acl cmake docbook_xml_dtd_45 docbook5_xsl epoxy fam gpgme
                libgcrypt libgit2 modemmanager networkmanager perl
                perlPackages qimageblitz xlibs zlib;
        boost = boost156;
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
    inherit kdePackage scope;

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

    frameworkintegration = overrideDerivation super.frameworkintegration (drv: {
      buildInputs = drv.buildInputs ++ [ pkgs.xlibs.libXcursor ];
    });

    kauth = overrideDerivation super.kauth (drv: {
      buildInputs = drv.buildInputs ++ [ scope.polkit_qt5 ];
      patches = [./kauth/kauth-policy-install.patch];
    });

    kcmutils = overrideDerivation super.kcmutils (drv: {
      patches = [./kcmutils/kcmutils-pluginselector-follow-symlinks.patch];
    });

    kconfigwidgets = overrideDerivation super.kconfigwidgets (drv: {
      patches = [./kconfigwidgets/kconfigwidgets-helpclient-follow-symlinks.patch];
    });

    kdelibs4support = overrideDerivation super.kdelibs4support (drv: {
      buildInputs = drv.buildInputs ++ [ scope.networkmanager pkgs.xlibs.libSM ];
      cmakeFlags =
        drv.cmakeFlags
        ++ [
          "-DDocBookXML4_DTD_DIR=${pkgs.docbook_xml_dtd_45}/xml/dtd/docbook"
          "-DDocBookXML4_DTD_VERSION=4.5"
        ];
    });

    kdoctools = overrideDerivation super.kdoctools (drv: {
      propagatedNativeBuildInputs =
        drv.propagatedNativeBuildInputs ++ [ scope.perl scope.perlPackages.URI ];
      cmakeFlags =
        drv.cmakeFlags
        ++ [
          "-DDocBookXML4_DTD_DIR=${pkgs.docbook_xml_dtd_45}/xml/dtd/docbook"
          "-DDocBookXML4_DTD_VERSION=4.5"
          "-DDocBookXSL_DIR=${pkgs.docbook5_xsl}/xml/xsl/docbook"
        ];
      patches = [./kdoctools/kdoctools-no-find-docbook-xml.patch];
    });

    ki18n = overrideDerivation super.ki18n (drv: {
      propagatedNativeBuildInputs =
        drv.propagatedNativeBuildInputs ++ [ scope.libintl scope.pythoninterp ];
    });

    kimageformats = overrideDerivation super.kimageformats (drv: {
      NIX_CFLAGS_COMPILE = "-I${pkgs.ilmbase}/include/OpenEXR";
    });

    kinit = overrideDerivation super.kinit (drv: {
      patches = [./kinit/0001-kinit-libpath.patch];
    });

    kpackage = overrideDerivation super.kpackage (drv: {
      patches = [./kpackage/0001-allow-external-paths.patch];
    });

    kservice = overrideDerivation super.kservice (drv: {
      buildInputs = drv.buildInputs ++ [ self.kwindowsystem ];
      patches = [
        ./kservice/kservice-kbuildsycoca-follow-symlinks.patch
        ./kservice/kservice-kbuildsycoca-no-canonicalize-path.patch
      ];
    });

    ktexteditor = overrideDerivation super.ktexteditor (drv: {
      patches = [ ./ktexteditor/0001-no-qcoreapplication.patch ];
    });

    networkmanager-qt = overrideDerivation super.networkmanager-qt (drv: {
      propagatedBuildInputs = drv.propagatedBuildInputs ++ [ scope.networkmanager ];
    });
  };

in self
