{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, utilmacros, python
, libGL, libX11
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "epoxy-${version}";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "anholt";
    repo = "libepoxy";
    rev = "${version}";
    sha256 = "03nrmf161xyj3q9zsigr5qj5vx5dsfxxyjva73cm1mgqqc5d60px";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig utilmacros python ];
  buildInputs = [ libGL libX11 ];

  preConfigure = optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace build_glx=no build_glx=yes
    substituteInPlace src/dispatch_common.h --replace "PLATFORM_HAS_GLX 0" "PLATFORM_HAS_GLX 1"
  '';

  patches = [ ./libgl-path.patch ];

  NIX_CFLAGS_COMPILE = ''-DLIBGL_PATH="${getLib libGL}/lib"'';

  doCheck = false; # needs X11

  meta = {
    description = "A library for handling OpenGL function pointer management";
    homepage = https://github.com/anholt/libepoxy;
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
