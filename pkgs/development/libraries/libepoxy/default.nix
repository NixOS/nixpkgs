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

let
  inherit (lib) getLib optional optionalString;

in
stdenv.mkDerivation rec {
  pname = "libepoxy";
  version = "1.5.9";

  src = fetchFromGitHub {
    owner = "anholt";
    repo = pname;
    rev = version;
    sha256 = "sha256-8rdmC8FZUkKkEvWPJIdfrBQHiwa81vl5tmVqRdU4UIY=";
  };

  patches = [ ./libgl-path.patch ];

  postPatch = ''
    patchShebangs src/*.py
  ''
  + optionalString stdenv.isDarwin ''
    substituteInPlace src/dispatch_common.h --replace "PLATFORM_HAS_GLX 0" "PLATFORM_HAS_GLX 1"
  '';

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja pkg-config utilmacros python3 ];

  buildInputs = lib.optionals x11Support [
    libGL
    libX11
  ] ++ lib.optionals stdenv.isDarwin [
    Carbon
    OpenGL
  ];

  mesonFlags = [
    "-Dtests=${if doCheck then "true" else "false"}"
    "-Dglx=${if x11Support then "yes" else "no"}"
  ];

  NIX_CFLAGS_COMPILE = lib.optionalString x11Support ''-DLIBGL_PATH="${getLib libGL}/lib"'';

  # cgl_epoxy_api fails in darwin sandbox and on Hydra (because it's headless?)
  preCheck = lib.optionalString stdenv.isDarwin ''
    substituteInPlace ../test/meson.build \
      --replace "[ 'cgl_epoxy_api', [ 'cgl_epoxy_api.c' ] ]," ""
  '';

  # tests are running from version 1.5.9
  doCheck = true;

  meta = with lib; {
    description = "A library for handling OpenGL function pointer management";
    homepage = "https://github.com/anholt/libepoxy";
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu erictapen ];
    platforms = platforms.unix;
  };
}
