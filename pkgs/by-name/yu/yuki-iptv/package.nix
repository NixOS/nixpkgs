{
  bash,
  fetchurl,
  ffmpeg,
  gettext,
  glib,
  gobject-introspection,
  lib,
  mpv-unwrapped,
  python3,
  stdenv
}:

stdenv.mkDerivation rec {
  pname = "yuki-iptv";
  version = "0.0.15";

  src = fetchurl {
    url = "https://codeberg.org/liya/yuki-iptv/archive/${version}.tar.gz";
    sha256 = "sha256-8u8KoabExVqyj8ohGUl28SqIJYGfNLNl/tyHM9gwX88=";
  };

  buildInputs = [
    ffmpeg
    mpv-unwrapped
  ];

  nativeBuildInputs = [
    gettext
    python3.pkgs.wrapPython
  ];

  pythonPath = with python3.pkgs; [
    chardet
    pygobject3
    pyqt6
    pyqt6-sip
    requests
    setproctitle
    unidecode
    wand
  ];

  preFixup = ''
    buildPythonPath "$out $pythonPath"

    wrapProgram $out/bin/yuki-iptv \
      --prefix PYTHONPATH : "$program_PYTHONPATH" \
      --set GI_TYPELIB_PATH "${glib.out}/lib/girepository-1.0:${gobject-introspection.out}/lib/girepository-1.0" \
  '';

  postPatch = ''
    substituteInPlace usr/lib/yuki-iptv/yuki-iptv.py \
      --replace __DEB_VERSION__ ${version}

    substituteInPlace usr/bin/yuki-iptv \
      --replace "#!/bin/sh" "#!${bash}/bin/sh" \
      --replace "python3" "${python3}/bin/python3"

    substituteInPlace usr/lib/yuki-iptv/thirdparty/mpv.py \
      --replace "ctypes.util.find_library('mpv')" "'${lib.makeLibraryPath [ mpv-unwrapped ]}/libmpv.so'"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/* $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "IPTV player with EPG support";
    license = licenses.cc-by-40;
    platforms = platforms.linux;
    homepage = "https://codeberg.org/liya/yuki-iptv";
  };
}
