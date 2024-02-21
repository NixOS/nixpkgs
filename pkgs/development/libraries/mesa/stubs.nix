{ stdenv
, lib
, libglvnd
, OpenGL
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libGL";
  version = if stdenv.hostPlatform.isDarwin then "4.1" else libglvnd.version;
  outputs = [ "out" "dev" ];

  propagatedBuildInputs = lib.optionals stdenv.isDarwin [ OpenGL ];

  # On macOS, provide the OpenGL framework as well as a pkg-config file for OpenGL.framework.
  # Packages that still need GL_X_ specifically can pull in libGLX instead, which will be
  # Mesa, as libglvnd does not work on macOS.
  buildCommand = if stdenv.hostPlatform.isDarwin then ''
    mkdir -p $dev/lib/pkgconfig $dev/nix-support

    echo "$out" > $dev/nix-support/propagated-build-inputs

    mkdir -p $out/lib
    ln -s ${OpenGL}/Library/Frameworks/OpenGL.framework/Libraries/libGL.tbd $out/lib/libGL.tbd

    mkdir -p $dev/include
    ln -s ${OpenGL}/Library/Frameworks/OpenGL.framework/Headers $dev/include/GL

    cat <<EOF >$dev/lib/pkgconfig/gl.pc
  Name: gl
  Description: gl library
  Version: 4.1
  Libs: -F${OpenGL} -framework OpenGL
  Cflags: -F${OpenGL}
  EOF
  ''

  # Otherwise, setup gl stubs to use libglvnd.
  else ''
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

  meta = {
    description = "Stub bindings using " + (if stdenv.hostPlatform.isDarwin then "OpenGL.framework" else "libglvnd");
    pkgConfigModules = [ "gl" ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ "egl" "glesv1_cm" "glesv2" ];
  } // (if stdenv.hostPlatform.isDarwin
    then { inherit (OpenGL.meta) platforms; }
    else { inherit (libglvnd.meta) homepage license platforms badPlatforms; });
})
