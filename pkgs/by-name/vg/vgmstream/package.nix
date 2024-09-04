{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, gtk3
, audacious, mpg123, ffmpeg, libvorbis, libao, jansson, speex
, nix-update-script
, buildAudaciousPlugin ? false  # only build cli by default, pkgs.audacious-plugins sets this to enable plugin support
}:

stdenv.mkDerivation rec {
  pname = "vgmstream";
  version = "1951";

  src = fetchFromGitHub {
    owner = "vgmstream";
    repo = "vgmstream";
    rev = "refs/tags/r${version}";
    sha256 = "sha256-Wa0FAUHdJtG+u9y3ZOt8dxRIo78lekFPghiu67KJZ9s=";
  };

  passthru.updateScript = nix-update-script {
    attrPath = "vgmstream";
    extraArgs = [ "--version-regex" "r(.*)" ];
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optional buildAudaciousPlugin gtk3;

  buildInputs = [
    mpg123
    ffmpeg
    libvorbis
    libao
    jansson
    speex
  ] ++ lib.optional buildAudaciousPlugin (audacious.override { audacious-plugins = null; });

  preConfigure = ''
    substituteInPlace cmake/dependencies/audacious.cmake \
      --replace "pkg_get_variable(AUDACIOUS_PLUGIN_DIR audacious plugin_dir)" "set(AUDACIOUS_PLUGIN_DIR \"$out/lib/audacious\")"
  '';

  cmakeFlags = [
    # It always tries to download it, no option to use the system one
    "-DUSE_CELT=OFF"
  ] ++ lib.optional (! buildAudaciousPlugin) "-DBUILD_AUDACIOUS=OFF";

  meta = with lib; {
    description = "Library for playback of various streamed audio formats used in video games";
    homepage    = "https://vgmstream.org";
    maintainers = with maintainers; [ zane ];
    license     = with licenses; isc;
    platforms   = with platforms; unix;
  };
}
