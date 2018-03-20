{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, utilmacros, python
, libGL, libX11
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "epoxy-${version}";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "anholt";
    repo = "libepoxy";
    rev = "${version}";
    sha256 = "1ixpqb10pmdy3n9nxd5inflig9dal5502ggadcns5b58j6jr0yv0";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig utilmacros python ];
  buildInputs = [ libGL libX11 ];

  preConfigure = optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace build_glx=no build_glx=yes
    substituteInPlace src/dispatch_common.h --replace "PLATFORM_HAS_GLX 0" "PLATFORM_HAS_GLX 1"
  '';

  # add libGL to rpath because libepoxy dlopen()s libEGL
  postFixup = optionalString stdenv.isLinux ''
    patchelf --set-rpath "${stdenv.lib.makeLibraryPath [ libGL ]}:$(patchelf --print-rpath $out/lib/libepoxy.so.0.0.0)" $out/lib/libepoxy.so.0.0.0
  '';

  meta = {
    description = "A library for handling OpenGL function pointer management";
    homepage = https://github.com/anholt/libepoxy;
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
