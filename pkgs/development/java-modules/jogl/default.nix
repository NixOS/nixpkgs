{ coreutils, lib, stdenv, fetchgit, ant, jdk8, jdk11, git, xorg, udev, libGL, libGLU, mesa, xmlstarlet, xcbuild, darwin }:

{
  jogl_2_4_0 =
    let
      version = "2.4.0";

      gluegen-src = fetchgit {
        url = "git://jogamp.org/srv/scm/gluegen.git";
        rev = "v${version}";
        hash = "sha256-qQzq7v2vMFeia6gXaNHS3AbOp9HhDRgISp7P++CKErA=";
        fetchSubmodules = true;
      };
      jogl-src = fetchgit {
        url = "git://jogamp.org/srv/scm/jogl.git";
        rev = "v${version}";
        hash = "sha256-PHDq7uFEQfJ2P0eXPUi0DGFR1ob/n5a68otgzpFnfzQ=";
        fetchSubmodules = true;
      };
    in
    stdenv.mkDerivation {
      pname = "jogl";
      inherit version;

      srcs = [ gluegen-src jogl-src ];
      sourceRoot = ".";

      unpackCmd = "cp -r $curSrc \${curSrc##*-}";

      postPatch = lib.optionalString stdenv.isDarwin ''
        sed -i '/if="use.macos/d' gluegen/make/gluegen-cpptasks-base.xml
        rm -r jogl/oculusvr-sdk
      '';

      nativeBuildInputs = [ ant jdk11 git xmlstarlet ]
        ++ lib.optionals stdenv.isDarwin [ xcbuild ];
      buildInputs = lib.optionals stdenv.isLinux [ udev xorg.libX11 xorg.libXrandr xorg.libXcursor xorg.libXi xorg.libXt xorg.libXxf86vm xorg.libXrender mesa ]
        ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk_11_0.frameworks.AppKit darwin.apple_sdk_11_0.frameworks.Cocoa ];

      # Workaround build failure on -fno-common toolchains:
      #   ld: ../obj/Bindingtest1p1Impl_JNI.o:(.bss+0x8): multiple definition of
      #     `unsigned_size_t_1'; ../obj/TK_Surface_JNI.o:(.bss+0x8): first defined here
      NIX_CFLAGS_COMPILE = "-fcommon"; # copied from 2.3.2, is this still needed?

      buildPhase = ''
        ( cd gluegen/make
          substituteInPlace ../src/java/com/jogamp/common/util/IOUtil.java --replace '#!/bin/true' '#!${coreutils}/bin/true'

          # set timestamp of files in jar to a fixed point in time
          xmlstarlet ed --inplace \
             --append //jar --type attr -n modificationtime --value 1980-01-01T00:00Z \
             build.xml gluegen-cpptasks-base.xml

          ant -Dtarget.sourcelevel=8 -Dtarget.targetlevel=8 -Dtarget.rt.jar='null.jar' )

        ( cd jogl/make

          # prevent looking for native libraries in /usr/lib
          substituteInPlace build-*.xml \
            --replace 'dir="''${TARGET_PLATFORM_USRLIBS}"' ""

          # force way to do disfunctional "ant -Dsetup.addNativeBroadcom=false" and disable dependency on raspberrypi drivers
          # if arm/aarch64 support will be added, this block might be commented out on those platforms
          # on x86 compiling with default "setup.addNativeBroadcom=true" leads to unsatisfied import "vc_dispmanx_resource_delete" in libnewt.so
          xmlstarlet ed --inplace --delete '//*[@if="setup.addNativeBroadcom"]' build-newt.xml

          # set timestamp of files in jar to a fixed point in time
          xmlstarlet ed --inplace \
             --append //jar --type attr -n modificationtime --value 1980-01-01T00:00Z \
             build.xml build-nativewindow.xml build-jogl.xml

          ant -Dtarget.sourcelevel=8 -Dtarget.targetlevel=8 -Dtarget.rt.jar='null.jar' )
      '';

      installPhase = ''
        mkdir -p $out/share/java
        cp -v $NIX_BUILD_TOP/gluegen/build/gluegen-rt{,-natives-linux-*}.jar $out/share/java/
        cp -v $NIX_BUILD_TOP/jogl/build/jar/jogl-all{,-natives-linux-*}.jar  $out/share/java/
        cp -v $NIX_BUILD_TOP/jogl/build/nativewindow/nativewindow{,-awt,-natives-linux-*,-os-drm,-os-x11}.jar  $out/share/java/
      '';

      meta = with lib; {
        description = "Java libraries for 3D Graphics, Multimedia and Processing";
        homepage = "https://jogamp.org/";
        license = licenses.bsd3;
        platforms = platforms.all;
      };
    };
}
