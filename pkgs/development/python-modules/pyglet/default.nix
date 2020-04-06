{ stdenv
, buildPythonPackage
, fetchPypi
, libGL
, libGLU
, xorg
, future
, pytest
, glibc
, gtk2-x11
, gdk-pixbuf
, fontconfig
, freetype
, ffmpeg-full
}:

buildPythonPackage rec {
  version = "1.4.2";
  pname = "pyglet";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dxxrl4nc7xh3aai1clgzvk48bvd35r7ksirsddz0mwhx7jmm8px";
  };

  # find_library doesn't reliably work with nix (https://github.com/NixOS/nixpkgs/issues/7307).
  # Even naively searching `LD_LIBRARY_PATH` won't work since `libc.so` is a linker script and
  # ctypes.cdll.LoadLibrary cannot deal with those. Therefore, just hardcode the paths to the
  # necessary libraries.
  postPatch = let
    ext = stdenv.hostPlatform.extensions.sharedLibrary;
  in ''
    cat > pyglet/lib.py <<EOF
    import ctypes
    def load_library(*names, **kwargs):
        for name in names:
            path = None
            if name == 'GL':
                path = '${libGL}/lib/libGL${ext}'
            elif name == 'GLU':
                path = '${libGLU}/lib/libGLU${ext}'
            elif name == 'c':
                path = '${glibc}/lib/libc${ext}.6'
            elif name == 'X11':
                path = '${xorg.libX11}/lib/libX11${ext}'
            elif name == 'gdk-x11-2.0':
                path = '${gtk2-x11}/lib/libgdk-x11-2.0${ext}'
            elif name == 'gdk_pixbuf-2.0':
                path = '${gdk-pixbuf}/lib/libgdk_pixbuf-2.0${ext}'
            elif name == 'Xext':
                path = '${xorg.libXext}/lib/libXext${ext}'
            elif name == 'fontconfig':
                path = '${fontconfig.lib}/lib/libfontconfig${ext}'
            elif name == 'freetype':
                path = '${freetype}/lib/libfreetype${ext}'
            elif name[0:2] == 'av' or name[0:2] == 'sw':
                path = '${ffmpeg-full}/lib/lib' + name + '${ext}'
            if path is not None:
                return ctypes.cdll.LoadLibrary(path)
        raise Exception("Could not load library {}".format(names))
    EOF
  '';

  propagatedBuildInputs = [ future ];

  # needs an X server. Keep an eye on
  # https://bitbucket.org/pyglet/pyglet/issues/219/egl-support-headless-rendering
  doCheck = false;

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    py.test tests/unit tests/integration
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.pyglet.org/";
    description = "A cross-platform windowing and multimedia library";
    license = licenses.bsd3;
    platforms = platforms.mesaPlatforms;
  };
}
