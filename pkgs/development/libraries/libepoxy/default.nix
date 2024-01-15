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
, x11Support ? !stdenv.isDarwin
}:

stdenv.mkDerivation rec {
  pname = "libepoxy";
  version = "1.5.10";

  src = fetchFromGitHub {
    owner = "anholt";
    repo = pname;
    rev = version;
    sha256 = "sha256-gZiyPOW2PeTMILcPiUTqPUGRNlMM5mI1z9563v4SgEs=";
  };

  patches = [ ./libgl-path.patch ];

  postPatch = ''
    patchShebangs src/*.py
  ''
  + lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/dispatch_common.h --replace "PLATFORM_HAS_GLX 0" "PLATFORM_HAS_GLX 1"
  ''
  # cgl_core and cgl_epoxy_api fail in darwin sandbox and on Hydra (because it's headless?)
  + lib.optionalString stdenv.isDarwin ''
    substituteInPlace test/meson.build \
      --replace "[ 'cgl_epoxy_api', [ 'cgl_epoxy_api.c' ] ]," ""
  ''
  + lib.optionalString (stdenv.isDarwin && stdenv.isx86_64) ''
    substituteInPlace test/meson.build \
      --replace "[ 'cgl_core', [ 'cgl_core.c' ] ]," ""
  '';

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja pkg-config utilmacros python3 ];

  buildInputs = lib.optionals (x11Support && !stdenv.isDarwin) [
    libGL
  ] ++ lib.optionals x11Support [
    libX11
  ] ++ lib.optionals stdenv.isDarwin [
    Carbon
    OpenGL
  ];

  mesonFlags = [
    "-Degl=${if (x11Support && !stdenv.isDarwin) then "yes" else "no"}"
    "-Dglx=${if x11Support then "yes" else "no"}"
    "-Dtests=${lib.boolToString doCheck}"
    "-Dx11=${lib.boolToString x11Support}"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString (x11Support && !stdenv.isDarwin) ''-DLIBGL_PATH="${lib.getLib libGL}/lib"'';

  doCheck = true;

  meta = with lib; {
    description = "A library for handling OpenGL function pointer management";
    homepage = "https://github.com/anholt/libepoxy";
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.unix;
    pkgConfigModules = [ "epoxy" ];
  };
}
