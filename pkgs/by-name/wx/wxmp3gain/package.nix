{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gettext,
  wxGTK32,
  mp3gain,
}:

stdenv.mkDerivation rec {
  pname = "wxmp3gain";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "cfgnunes";
    repo = "wxmp3gain";
    rev = version;
    hash = "sha256-264HSGJXXt27ZiiDUsIIjCuU2WFB0sEkwnglTH5xXww=";
  };

  nativeBuildInputs = [
    cmake
    gettext
  ];

  buildInputs = [
    wxGTK32
    mp3gain
  ];

  postInstall = ''
    # Make data/ reachable next to the binary as expected by getDataDir()
    ln -s ../share/wxmp3gain/data $out/bin/data
  '';

  meta = {
    description = "Free front-end for the MP3gain";
    longDescription = ''
      wxMP3gain is a free front-end for MP3gain, providing a graphical
      interface to analyze and adjust the volume of MP3 files without
      re-encoding.
    '';
    homepage = "https://github.com/cfgnunes/wxmp3gain";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "wxmp3gain";
  };
}
