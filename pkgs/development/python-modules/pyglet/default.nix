{ stdenv
, buildPythonPackage
, fetchPypi
, libGLU_combined
, xorg
, future
, pytest
, glibc
, gtk2-x11
, gdk_pixbuf
}:

buildPythonPackage rec {
  version = "1.3.2";
  pname = "pyglet";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b00570e7cdf6971af8953b6ece50d83d13272afa5d1f1197c58c0f478dd17743";
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
                path = '${libGLU_combined}/lib/libGL${ext}'
            elif name == 'GLU':
                path = '${libGLU_combined}/lib/libGLU${ext}'
            elif name == 'c':
                path = '${glibc}/lib/libc${ext}.6'
            elif name == 'X11':
                path = '${xorg.libX11}/lib/libX11${ext}'
            elif name == 'gdk-x11-2.0':
                path = '${gtk2-x11}/lib/libgdk-x11-2.0${ext}'
            elif name == 'gdk_pixbuf-2.0':
                path = '${gdk_pixbuf}/lib/libgdk_pixbuf-2.0${ext}'
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
