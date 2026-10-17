{
  lib,
  stdenv,
  fetchzip,
  pkg-config,

  # Depencies
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

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isLinux pkg-config;
  buildInputs = lib.optional stdenv.hostPlatform.isLinux libx11;

  patches = lib.optional stdenv.hostPlatform.isLinux ./showme.c-font-patch.patch;

  # Old K&R-style function declarations
  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CSWITCHES=-O2 -std=gnu17 ${lib.optionalString stdenv.hostPlatform.isLinux " -DLINUX -I${libx11.dev}/include -L${lib.getLib libx11}/lib"}"
  ];

  buildFlags = [
    "triangle"
    "trilibrary"
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux "showme";

  outputs = [
    "out"
    "dev"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp triangle $out/bin
    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      cp showme $out/bin
    ''}

    mkdir -p $dev/include $dev/lib
    cp triangle.o $dev/lib
    cp $src/triangle.h $dev/include

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/triangle -h
    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      $out/bin/showme -h
    ''}

    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://www.cs.cmu.edu/~quake/triangle.html";
    license = lib.licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
    description = "A Two-Dimensional Quality Mesh Generator and Delaunay Triangulator.";
    mainProgram = "triangle";
  };
})
