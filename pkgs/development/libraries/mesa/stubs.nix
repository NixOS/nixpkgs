{
  stdenv,
  libglvnd,
  mesa,
  OpenGL,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libGL";
  inherit (if stdenv.hostPlatform.isDarwin then mesa else libglvnd) version;
  outputs = [
    "out"
    "dev"
  ];

  # On macOS, libglvnd is not supported, so we just use what mesa
  # build. We need to also include OpenGL.framework, and some
  # extra tricks to go along with. We add mesa’s libGLX to support
  # the X extensions to OpenGL.
  buildCommand =
    if stdenv.hostPlatform.isDarwin then
      ''
          mkdir -p $out/nix-support $dev
          echo ${OpenGL} >> $out/nix-support/propagated-build-inputs
          ln -s ${mesa.out}/lib $out/lib

          mkdir -p $dev/lib/pkgconfig $dev/nix-support
          echo "$out" > $dev/nix-support/propagated-build-inputs
          ln -s ${mesa.dev}/include $dev/include

          cat <<EOF >$dev/lib/pkgconfig/gl.pc
        Name: gl
        Description: gl library
        Version: ${mesa.version}
        Libs: -L${mesa.out}/lib -lGL
        Cflags: -I${mesa.dev}/include
        EOF

          cat <<EOF >$dev/lib/pkgconfig/glesv1_cm.pc
        Name: glesv1_cm
        Description: glesv1_cm library
        Version: ${mesa.version}
        Libs: -L${mesa.out}/lib -lGLESv1_CM
        Cflags: -I${mesa.dev}/include
        EOF

          cat <<EOF >$dev/lib/pkgconfig/glesv2.pc
        Name: glesv2
        Description: glesv2 library
        Version: ${mesa.version}
        Libs: -L${mesa.out}/lib -lGLESv2
        Cflags: -I${mesa.dev}/include
        EOF
      ''

    # Otherwise, setup gl stubs to use libglvnd.
    else
      ''
        mkdir -p $out/nix-support
        ln -s ${libglvnd.out}/lib $out/lib

        mkdir -p $dev/{,lib/pkgconfig,nix-support}
        echo "$out ${libglvnd} ${libglvnd.dev}" > $dev/nix-support/propagated-build-inputs
        ln -s ${libglvnd.dev}/include $dev/include

        genPkgConfig() {
          local name="$1"
          local lib="$2"

          cat <<EOF >$dev/lib/pkgconfig/$name.pc
        Name: $name
        Description: $lib library
        Version: ${libglvnd.version}
        Libs: -L${libglvnd.out}/lib -l$lib
        Cflags: -I${libglvnd.dev}/include
        EOF
        }

        genPkgConfig gl GL
        genPkgConfig egl EGL
        genPkgConfig glesv1_cm GLESv1_CM
        genPkgConfig glesv2 GLESv2
      '';

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta =
    {
      description =
        "Stub bindings using " + (if stdenv.hostPlatform.isDarwin then "mesa" else "libglvnd");
      pkgConfigModules = [
        "gl"
        "egl"
        "glesv1_cm"
        "glesv2"
      ];
    }
    // {
      inherit (if stdenv.hostPlatform.isDarwin then mesa.meta else libglvnd.meta)
        homepage
        license
        platforms
        badPlatforms
        ;
    };
})
