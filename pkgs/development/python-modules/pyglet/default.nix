{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  unzip,
  pythonOlder,
  libGL,
  libGLU,
  xorg,
  pytestCheckHook,
  glibc,
  gtk2-x11,
  gdk-pixbuf,
  fontconfig,
  freetype,
  ffmpeg-full,
  openal,
  libpulseaudio,
  harfbuzz,
  mesa,
  apple-sdk,
}:

buildPythonPackage rec {
  version = "2.0.10";
  format = "setuptools";
  pname = "pyglet";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JCvrGzvWfFvr3+W6EexWtpathrUMbn8qMX+NeDJWuck=";
    extension = "zip";
  };

  # find_library doesn't reliably work with nix (https://github.com/NixOS/nixpkgs/issues/7307).
  # Even naively searching `LD_LIBRARY_PATH` won't work since `libc.so` is a linker script and
  # ctypes.cdll.LoadLibrary cannot deal with those. Therefore, just hardcode the paths to the
  # necessary libraries.
  postPatch =
    let
      ext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    lib.optionalString stdenv.isLinux ''
      cat > pyglet/lib.py <<EOF
      import ctypes
      def load_library(*names, **kwargs):
          for name in names:
              path = None
              if name == 'GL':
                  path = '${libGL}/lib/libGL${ext}'
              elif name == 'EGL':
                  path = '${libGL}/lib/libEGL${ext}'
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
                  path = '${lib.getLib ffmpeg-full}/lib/lib' + name + '${ext}'
              elif name == 'openal':
                  path = '${openal}/lib/libopenal${ext}'
              elif name == 'pulse':
                  path = '${libpulseaudio}/lib/libpulse${ext}'
              elif name == 'Xi':
                  path = '${xorg.libXi}/lib/libXi${ext}'
              elif name == 'Xinerama':
                  path = '${xorg.libXinerama}/lib/libXinerama${ext}'
              elif name == 'Xxf86vm':
                  path = '${xorg.libXxf86vm}/lib/libXxf86vm${ext}'
              elif name == 'harfbuzz':
                  path = '${harfbuzz}/lib/libharfbuzz${ext}'
              if path is not None:
                  return ctypes.cdll.LoadLibrary(path)
          raise Exception("Could not load library {}".format(names))
      EOF
    ''
    + lib.optionalString stdenv.isDarwin ''
      cat > pyglet/lib.py <<EOF
      import os
      import ctypes
      def load_library(*names, **kwargs):
          path = None
          framework = kwargs.get('framework')
          if framework is not None:
            path = '${apple-sdk}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/{framework}.framework/{framework}'.format(framework=framework)
          else:
              names = kwargs.get('darwin', names)
              if not isinstance(names, tuple):
                  names = (names,)
              for name in names:
                  if name == "libharfbuzz.0.dylib":
                      path = '${harfbuzz}/lib/%s' % name
                      break
                  elif name.startswith('avutil'):
                      path = '${lib.getLib ffmpeg-full}/lib/lib%s.dylib' % name
                      if not os.path.exists(path):
                          path = None
                      else:
                          break
          if path is not None:
              return ctypes.cdll.LoadLibrary(path)
          raise ImportError("Could not load library {}".format(names))
      EOF
    '';

  nativeBuildInputs = [ unzip ];

  # needs GL set up which isn't really possible in a build environment even in headless mode.
  # tests do run and pass in nix-shell, however.
  doCheck = false;

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = # libEGL only available on Linux (despite meta.platforms on libGL)
    lib.optionalString stdenv.isLinux ''
      export PYGLET_HEADLESS=True
    '';

  # test list taken from .travis.yml
  disabledTestPaths = [
    "tests/base"
    "tests/interactive"
    "tests/integration"
    "tests/unit/text/test_layout.py"
  ];

  pythonImportsCheck = [ "pyglet" ];

  meta = {
    homepage = "http://www.pyglet.org/";
    description = "Cross-platform windowing and multimedia library";
    license = lib.licenses.bsd3;
    # The patch needs adjusting for other platforms.
    platforms = with lib.platforms; linux ++ darwin;
  };
}
