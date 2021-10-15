/*

# Updates

Before a major version update, make a copy of this directory. (We like to
keep the old version around for a short time after major updates.) Add a
top-level attribute to `top-level/all-packages.nix`.

1. Update the URL in `pkgs/development/libraries/qt-5/$VERSION/fetch.sh`.
2. From the top of the Nixpkgs tree, run
   `./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-5/$VERSION`.
3. Check that the new packages build correctly.
4. Commit the changes and open a pull request.

*/

{ newScope
, lib, stdenv, fetchurl, fetchgit, fetchpatch, fetchFromGitHub, makeSetupHook, makeWrapper
, bison, cups ? null, harfbuzz, libGL, perl
, gstreamer, gst-plugins-base, gtk3, dconf
, llvmPackages_5, darwin

  # options
, developerBuild ? false
, decryptSslTraffic ? false
, debug ? false
}:

let

  qtCompatVersion = srcs.qtbase.version;

  stdenvActual = if stdenv.cc.isClang then llvmPackages_5.stdenv else stdenv;

  mirror = "https://download.qt.io";
  srcs = import ./srcs.nix { inherit fetchurl; inherit mirror; } // {
    # qtwebkit does not have an official release tarball on the qt mirror and is
    # mostly maintained by the community.
    qtwebkit = rec {
      src = fetchFromGitHub {
        owner = "qt";
        repo = "qtwebkit";
        rev = "v${version}";
        sha256 = "0x8rng96h19xirn7qkz3lydal6v4vn00bcl0s3brz36dfs0z8wpg";
      };
      version = "5.212.0-alpha4";
    };
    qtwebengine =
      let
        branchName = "5.15.6";
        rev = "v${branchName}-lts";
      in
      {
        version = "${branchName}-${lib.substring 0 7 rev}";

        src = fetchgit {
          url = "https://github.com/qt/qtwebengine.git";
          sha256 = "17bw9yf04zmr9ck5jkrd435c8b03zpf937vn2nwgsr8p78wkg3kr";
          inherit rev branchName;
          fetchSubmodules = true;
          leaveDotGit = true;
          name = "qtwebengine-${lib.substring 0 7 rev}.tar.gz";
          postFetch = ''
            # remove submodule .git directory
            rm -rf "$out/src/3rdparty/.git"

            # compress to not exceed the 2GB output limit
            # try to make a deterministic tarball
            tar -I 'gzip -n' \
              --sort=name \
              --mtime=1970-01-01 \
              --owner=root --group=root \
              --numeric-owner --mode=go=rX,u+rw,a-s \
              --transform='s@^@source/@' \
              -cf temp  -C "$out" .
            rm -r "$out"
            mv temp "$out"
          '';
        };
      };
  };

  patches = {
    qtbase = lib.optionals stdenv.isDarwin [
      ./qtbase.patch.d/0001-qtbase-mkspecs-mac.patch

      # Downgrade minimal required SDK to 10.12
      ./qtbase.patch.d/0013-define-kiosurfacesuccess.patch
      ./qtbase.patch.d/macos-sdk-10.12/0001-Revert-QCocoaDrag-set-image-only-on-the-first-drag-i.patch
      ./qtbase.patch.d/macos-sdk-10.12/0002-Revert-QCocoaDrag-drag-make-sure-clipboard-is-ours-a.patch
      ./qtbase.patch.d/macos-sdk-10.12/0003-Revert-QCocoaDrag-maybeDragMultipleItems-fix-erroneo.patch
      ./qtbase.patch.d/macos-sdk-10.12/0004-Revert-QCocoaDrag-avoid-using-the-deprecated-API-if-.patch
      ./qtbase.patch.d/macos-sdk-10.12/0005-Revert-macOS-Fix-use-of-deprecated-NSOffState.patch
      ./qtbase.patch.d/macos-sdk-10.12/0006-git-checkout-v5.15.0-src-plugins-platforms-cocoa-qco.patch
      ./qtbase.patch.d/qtbase-sdk-10.12-mac.patch

      # Patch framework detection to support X.framework/X.tbd,
      # extending the current support for X.framework/X.
      ./qtbase.patch.d/0012-qtbase-tbd-frameworks.patch
    ] ++ [
      ./qtbase.patch.d/0003-qtbase-mkspecs.patch
      ./qtbase.patch.d/0004-qtbase-replace-libdir.patch
      ./qtbase.patch.d/0005-qtbase-cmake.patch
      ./qtbase.patch.d/0006-qtbase-gtk3.patch
      ./qtbase.patch.d/0007-qtbase-xcursor.patch
      ./qtbase.patch.d/0008-qtbase-tzdir.patch
      ./qtbase.patch.d/0009-qtbase-qtpluginpath.patch
      ./qtbase.patch.d/0010-qtbase-assert.patch
      ./qtbase.patch.d/0011-fix-header_module.patch
      (fetchpatch { # This can be removed when https://codereview.qt-project.org/c/qt/qtbase/+/339323 is included in an release.
        name = "0014-gcc11-compat.patch";
        url = "https://codereview.qt-project.org/gitweb?p=qt/qtbase.git;a=patch;h=049e14870c13235cd066758f29c42dc96c1ccdf8";
        sha256 = "1cb2hwi859hds0fa2cbap014qaa7mah9p0rcxcm2cvj2ybl33qfc";
      })
      (fetchpatch { # This can be removed when https://codereview.qt-project.org/c/qt/qtbase/+/363880/3 is included in an release.
        name = "qtbase-mysql-version-vs-functionality-check.patch";
        url = "https://codereview.qt-project.org/gitweb?p=qt/qtbase.git;a=patch;h=211369133cf40b2f522caaff259c19069ed23ca4";
        sha256 = "19kq9h10qm344fpdqa9basrbzh1y5kr48c6jzz3nvk61pk4ja1k4";
      })
    ];
    qtdeclarative = [ ./qtdeclarative.patch ];
    qtscript = [ ./qtscript.patch ];
    qtserialport = [ ./qtserialport.patch ];
    qtwebengine = [
      # Fix invisible fonts with glibc 2.33: https://github.com/NixOS/nixpkgs/issues/131074
      (fetchpatch {
        url = "https://src.fedoraproject.org/rpms/qt5-qtwebengine/raw/d122c011631137b79455850c363676c655cf9e09/f/qtwebengine-everywhere-src-5.15.5-%231904652.patch";
        name = "qtwebengine-everywhere-src-5.15.5-_1904652.patch";
        sha256 = "01q7hagq0ysii1jnrh5adm97vdm9cis592xr6im7accyw6hgcn7b";
      })
    ] ++ lib.optionals stdenv.isDarwin [
      ./qtwebengine-darwin-no-platform-check.patch
      ./qtwebengine-mac-dont-set-dsymutil-path.patch
    ];
    qtwebkit = [
      (fetchpatch {
        name = "qtwebkit-bison-3.7-build.patch";
        url = "https://github.com/qtwebkit/qtwebkit/commit/d92b11fea65364fefa700249bd3340e0cd4c5b31.patch";
        sha256 = "0h8ymfnwgkjkwaankr3iifiscsvngqpwb91yygndx344qdiw9y0n";
      })
      (fetchpatch {
        name = "qtwebkit-glib-2.68.patch";
        url = "https://github.com/qtwebkit/qtwebkit/pull/1058/commits/5b698ba3faffd4e198a45be9fe74f53307395e4b.patch";
        sha256 = "0a3xv0h4lv8wggckgy8cg8xnpkg7n9h45312pdjdnnwy87xvzss0";
      })
      ./qtwebkit.patch
      ./qtwebkit-icu68.patch
    ] ++ lib.optionals stdenv.isDarwin [
      ./qtwebkit-darwin-no-readline.patch
      ./qtwebkit-darwin-no-qos-classes.patch
    ];
    qttools = [ ./qttools.patch ];
  };

  qtModule =
    import ../qtModule.nix
    {
      inherit perl;
      inherit lib;
      # Use a variant of mkDerivation that does not include wrapQtApplications
      # to avoid cyclic dependencies between Qt modules.
      mkDerivation =
        import ../mkDerivation.nix
        { inherit lib; inherit debug; wrapQtAppsHook = null; }
        stdenvActual.mkDerivation;
    }
    { inherit self srcs patches; };

  addPackages = self: with self;
    let
      callPackage = self.newScope { inherit qtCompatVersion qtModule srcs; };
    in {

      inherit callPackage qtCompatVersion qtModule srcs;

      mkDerivationWith =
        import ../mkDerivation.nix
        { inherit lib; inherit debug; inherit (self) wrapQtAppsHook; };

      mkDerivation = mkDerivationWith stdenvActual.mkDerivation;

      qtbase = callPackage ../modules/qtbase.nix {
        inherit (srcs.qtbase) src version;
        patches = patches.qtbase;
        inherit bison cups harfbuzz libGL;
        withGtk3 = true; inherit dconf gtk3;
        inherit developerBuild decryptSslTraffic;
        inherit (darwin.apple_sdk.frameworks) AGL AppKit ApplicationServices Carbon Cocoa CoreAudio CoreBluetooth
          CoreLocation CoreServices DiskArbitration Foundation OpenGL MetalKit IOKit;
        inherit (darwin) libobjc;
      };

      qt3d = callPackage ../modules/qt3d.nix {};
      qtcharts = callPackage ../modules/qtcharts.nix {};
      qtconnectivity = callPackage ../modules/qtconnectivity.nix {};
      qtdeclarative = callPackage ../modules/qtdeclarative.nix {};
      qtdoc = callPackage ../modules/qtdoc.nix {};
      qtgamepad = callPackage ../modules/qtgamepad.nix {};
      qtgraphicaleffects = callPackage ../modules/qtgraphicaleffects.nix {};
      qtimageformats = callPackage ../modules/qtimageformats.nix {};
      qtlocation = callPackage ../modules/qtlocation.nix {};
      qtmacextras = callPackage ../modules/qtmacextras.nix {};
      qtmultimedia = callPackage ../modules/qtmultimedia.nix {
        inherit gstreamer gst-plugins-base;
      };
      qtnetworkauth = callPackage ../modules/qtnetworkauth.nix {};
      qtquick1 = null;
      qtquickcontrols = callPackage ../modules/qtquickcontrols.nix {};
      qtquickcontrols2 = callPackage ../modules/qtquickcontrols2.nix {};
      qtscript = callPackage ../modules/qtscript.nix {};
      qtsensors = callPackage ../modules/qtsensors.nix {};
      qtserialbus = callPackage ../modules/qtserialbus.nix {};
      qtserialport = callPackage ../modules/qtserialport.nix {};
      qtspeech = callPackage ../modules/qtspeech.nix {};
      qtsvg = callPackage ../modules/qtsvg.nix {};
      qtscxml = callPackage ../modules/qtscxml.nix {};
      qttools = callPackage ../modules/qttools.nix {};
      qttranslations = callPackage ../modules/qttranslations.nix {};
      qtvirtualkeyboard = callPackage ../modules/qtvirtualkeyboard.nix {};
      qtwayland = callPackage ../modules/qtwayland.nix {};
      qtwebchannel = callPackage ../modules/qtwebchannel.nix {};
      qtwebengine = callPackage ../modules/qtwebengine.nix {
        inherit (srcs.qtwebengine) version;
        inherit (darwin) cctools libobjc libunwind xnu;
        inherit (darwin.apple_sdk.libs) sandbox;
        inherit (darwin.apple_sdk.frameworks) ApplicationServices AVFoundation Foundation ForceFeedback GameController AppKit
          ImageCaptureCore CoreBluetooth IOBluetooth CoreWLAN Quartz Cocoa LocalAuthentication;
      };
      qtwebglplugin = callPackage ../modules/qtwebglplugin.nix {};
      qtwebkit = callPackage ../modules/qtwebkit.nix {
        inherit (darwin) ICU;
        inherit (darwin.apple_sdk.frameworks) OpenGL;
      };
      qtwebsockets = callPackage ../modules/qtwebsockets.nix {};
      qtwebview = callPackage ../modules/qtwebview.nix {
        inherit (darwin.apple_sdk.frameworks) CoreFoundation WebKit;
      };
      qtx11extras = callPackage ../modules/qtx11extras.nix {};
      qtxmlpatterns = callPackage ../modules/qtxmlpatterns.nix {};

      env = callPackage ../qt-env.nix {};
      full = env "qt-full-${qtbase.version}" ([
        qt3d qtcharts qtconnectivity qtdeclarative qtdoc qtgraphicaleffects
        qtimageformats qtlocation qtmultimedia qtquickcontrols qtquickcontrols2
        qtscript qtsensors qtserialport qtsvg qttools qttranslations
        qtvirtualkeyboard qtwebchannel qtwebengine qtwebkit qtwebsockets
        qtwebview qtx11extras qtxmlpatterns
      ] ++ lib.optional (!stdenv.isDarwin) qtwayland
        ++ lib.optional (stdenv.isDarwin) qtmacextras);

      qmake = makeSetupHook {
        deps = [ self.qtbase.dev ];
        substitutions = {
          inherit debug;
          fix_qmake_libtool = ../hooks/fix-qmake-libtool.sh;
        };
      } ../hooks/qmake-hook.sh;

      wrapQtAppsHook = makeSetupHook {
        deps = [ self.qtbase.dev makeWrapper ]
          ++ lib.optional stdenv.isLinux self.qtwayland.dev;
      } ../hooks/wrap-qt-apps-hook.sh;
    };

   self = lib.makeScope newScope addPackages;

in self
