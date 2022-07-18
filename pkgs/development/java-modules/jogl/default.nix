{ lib, stdenv, fetchgit, ant, jdk8, git, xorg, udev, libGL, libGLU }:

{
  jogl_2_3_2 =
    let
      version = "2.3.2";

      gluegen-src = fetchgit {
        url = "git://jogamp.org/srv/scm/gluegen.git";
        rev = "v${version}";
        sha256 = "00hybisjwqs88p24dds652bzrwbbmhn2dpx56kp4j6xpadkp33d0";
        fetchSubmodules = true;
      };
    in stdenv.mkDerivation {
      pname = "jogl";
      inherit version;

      src = fetchgit {
        url = "git://jogamp.org/srv/scm/jogl.git";
        rev = "v${version}";
        sha256 = "0msi2gxiqm2yqwkmxqbh521xdrimw1fly20g890r357rcgj8fsn3";
        fetchSubmodules = true;
      };

      postPatch = ''
        find  .  -type f  -name '*.java' \
          -exec sed -i 's@"libGL.so"@"${libGL}/lib/libGL.so"@'    {} \; \
          -exec sed -i 's@"libGLU.so"@"${libGLU}/lib/libGLU.so"@' {} \;
      '';

      # TODO: upgrade to jdk https://github.com/NixOS/nixpkgs/pull/89731
      nativeBuildInputs = [ jdk8 ant git ];
      buildInputs = [ udev xorg.libX11 xorg.libXrandr xorg.libXcursor xorg.libXt xorg.libXxf86vm xorg.libXrender ];

      # Workaround build failure on -fno-common toolchains:
      #   ld: ../obj/Bindingtest1p1Impl_JNI.o:(.bss+0x8): multiple definition of
      #     `unsigned_size_t_1'; ../obj/TK_Surface_JNI.o:(.bss+0x8): first defined here
      NIX_CFLAGS_COMPILE = "-fcommon";

      buildPhase = ''
        cp -r ${gluegen-src} $NIX_BUILD_TOP/gluegen
        chmod -R +w $NIX_BUILD_TOP/gluegen
        ( cd ../gluegen/make
          ant )

        ( cd make

          # force way to do disfunctional "ant -Dsetup.addNativeBroadcom=false" and disable dependency on raspberrypi drivers
          # if arm/aarch64 support will be added, this block might be commented out on those platforms
          # on x86 compiling with default "setup.addNativeBroadcom=true" leads to unsatisfied import "vc_dispmanx_resource_delete" in libnewt.so
          cp build-newt.xml build-newt.xml.old
          fgrep -v 'if="setup.addNativeBroadcom"' build-newt.xml.old > build-newt.xml

          ant )
      '';

      installPhase = ''
        mkdir -p $out/share/java
        cp $NIX_BUILD_TOP/gluegen/build/gluegen-rt{,-natives-linux-amd64}.jar $out/share/java/
        cp $NIX_BUILD_TOP/jogl/build/jar/jogl-all{,-natives-linux-amd64}.jar  $out/share/java/
      '';

      meta = with lib; {
        description = "Java libraries for 3D Graphics, Multimedia and Processing";
        homepage = "https://jogamp.org/";
        license = licenses.bsd3;
        platforms = [ "x86_64-linux" ];
      };
    };
}
