{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, ffmpeg
, zlib
}:

stdenv.mkDerivation rec {
  pname = "ffms";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "FFMS";
    repo = "ffms2";
    rev = version;
    sha256 = "sha256-Ildl8hbKSFGh4MUBK+k8uYMDrOZD9NSMdPAWIIaGy4E=";
  };

  env.NIX_CFLAGS_COMPILE = "-fPIC";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  preAutoreconf = ''
    mkdir src/config
  '';

  buildInputs = [
    ffmpeg
    zlib
  ];

  # ffms includes a built-in vapoursynth plugin, see:
  # https://github.com/FFMS/ffms2#avisynth-and-vapoursynth-plugin
  postInstall = ''
    mkdir $out/lib/vapoursynth
    ln -s $out/lib/libffms2.so $out/lib/vapoursynth/libffms2.so
  '';

  meta = with lib; {
    homepage = "https://github.com/FFMS/ffms2";
    description = "FFmpeg based source library for easy frame accurate access";
    mainProgram = "ffmsindex";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
