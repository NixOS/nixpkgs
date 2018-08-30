{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, utilmacros, python
, libGL, libX11
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "epoxy-${version}";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "anholt";
    repo = "libepoxy";
    rev = "${version}";
    sha256 = "1811agxr7g9wd832np8sw152j468kg3qydmfkc564v54ncfcgaci";
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
