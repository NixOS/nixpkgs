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

  buildInputs = [ libGL libX11 ];

  mesonFlags = [
    "-Dtests=${if doCheck then "true" else "false"}"
  ]
  ++ optional stdenv.isDarwin "-Dglx=yes";

  NIX_CFLAGS_COMPILE = ''-DLIBGL_PATH="${getLib libGL}/lib"'';

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
