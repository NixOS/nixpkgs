{ stdenv
, lib
, fetchFromGitHub
, libpulseaudio
, libvorbis
}:

stdenv.mkDerivation rec {
  pname = "faun";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "WickedSmoke";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XfblM/EKd0fa8CHKpTLUTi7BTj8ASh6v/Mgu6W3RvOI=";
  };

  buildInputs = [
    libpulseaudio
    libvorbis
  ];

  configurePhase = ''
    patchShebangs .
    ./configure --prefix $out
  '';

  meta = with lib;{
    homepage = "https://github.com/WickedSmoke/faun";
    description = "A high-level C audio library";
    license = lib.licenses.gpl2Plus;
    maintainers = with maintainers; [ mausch ];
    platforms = with platforms; unix;
  };
}
