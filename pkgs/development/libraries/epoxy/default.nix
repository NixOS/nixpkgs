{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, utilmacros, python
, libGLU_combined, libX11
}:

stdenv.mkDerivation rec {
  name = "epoxy-${version}";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "anholt";
    repo = "libepoxy";
    rev = "v${version}";
    sha256 = "0dfkd4xbp7v5gwsf6qwaraz54yzizf3lj5ymyc0msjn0adq3j5yl";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig utilmacros python ];
  buildInputs = [ libGLU_combined libX11 ];

  preConfigure = stdenv.lib.optional stdenv.isDarwin ''
    substituteInPlace configure --replace build_glx=no build_glx=yes
    substituteInPlace src/dispatch_common.h --replace "PLATFORM_HAS_GLX 0" "PLATFORM_HAS_GLX 1"
  '';

  meta = with stdenv.lib; {
    description = "A library for handling OpenGL function pointer management";
    homepage = https://github.com/anholt/libepoxy;
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
