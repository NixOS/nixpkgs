{
  lib,
  stdenv,
  fetchzip,
  versionCheckHook,
  # deps
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "triangle";
  version = "1.6";

  src = fetchzip {
    url = "http://www.netlib.org/voronoi/${finalAttrs.pname}.zip";
    sha256 = "sha256-alRqdXDt+vphEU/rSTOz8iS+ixp25rlx5xKL75tWuW4=";
    stripRoot = false;
  };

  buildInputs = lib.optional stdenv.hostPlatform.isLinux libx11;

  patches = lib.optional stdenv.hostPlatform.isLinux ./showme.c-font-patch.patch;

  # Old K&R-style function declarations
  NIX_CFLAGS_COMPILE = [ "-std=gnu11" ] ++ lib.optional stdenv.hostPlatform.isLinux "-DLINUX";

  buildPhase = ''
    $CC -O -o triangle triangle.c -lm
    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      $CC -O -o showme showme.c -I${libx11.dev}/include -L${libx11}/lib -lX11
    ''}
    $CC -DTRILIBRARY -O -std=gnu11 -c -o triangle.o triangle.c
  '';

  outputs = [
    "out"
    "dev"
  ];

  installPhase = ''
    mkdir -p $out/bin $dev/include $dev/lib
    cp triangle $out/bin
    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      cp showme $out/bin
    ''}
    cp triangle.o $dev/lib
    cp $src/triangle.h $dev/include
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "-h";

  meta = {
    homepage = "https://www.cs.cmu.edu/~quake/triangle.html";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ WiredMic ];
    description = "A Two-Dimensional Quality Mesh Generator and Delaunay Triangulator.";
    mainProgram = "triangle";
  };
})
