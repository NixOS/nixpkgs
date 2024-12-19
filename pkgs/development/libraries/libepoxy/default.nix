{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, utilmacros
, python3
, libGL
, libX11
, Carbon
, OpenGL
, x11Support ? !stdenv.hostPlatform.isDarwin
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libepoxy";
  version = "1.5.10";

  src = with finalAttrs; fetchFromGitHub {
    owner = "anholt";
    repo = pname;
    rev = version;
    sha256 = "sha256-gZiyPOW2PeTMILcPiUTqPUGRNlMM5mI1z9563v4SgEs=";
  };

  patches = [ ./libgl-path.patch ];

  postPatch = ''
    patchShebangs src/*.py
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/dispatch_common.h --replace "PLATFORM_HAS_GLX 0" "PLATFORM_HAS_GLX 1"
  ''
  # cgl_core and cgl_epoxy_api fail in darwin sandbox and on Hydra (because it's headless?)
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace test/meson.build \
      --replace "[ 'cgl_epoxy_api', [ 'cgl_epoxy_api.c' ] ]," ""
  ''
  + lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) ''
    substituteInPlace test/meson.build \
      --replace "[ 'cgl_core', [ 'cgl_core.c' ] ]," ""
  '';

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja pkg-config utilmacros python3 ];

  buildInputs = lib.optionals (x11Support && !stdenv.hostPlatform.isDarwin) [
    libGL
  ] ++ lib.optionals x11Support [
    libX11
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Carbon
    OpenGL
  ];

  mesonFlags = [
    "-Degl=${if (x11Support && !stdenv.hostPlatform.isDarwin) then "yes" else "no"}"
    "-Dglx=${if x11Support then "yes" else "no"}"
    "-Dtests=${lib.boolToString finalAttrs.finalPackage.doCheck}"
    "-Dx11=${lib.boolToString x11Support}"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString (x11Support && !stdenv.hostPlatform.isDarwin) ''-DLIBGL_PATH="${lib.getLib libGL}/lib"'';

  doCheck = true;

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    description = "Library for handling OpenGL function pointer management";
    homepage = "https://github.com/anholt/libepoxy";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
    pkgConfigModules = [ "epoxy" ];
  };
})
