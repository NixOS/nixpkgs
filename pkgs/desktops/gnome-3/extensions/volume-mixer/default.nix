{ stdenv, fetchFromGitHub, glib, pulseaudio, python3 }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-volume-mixer";
  version = "3.36.6";

  src = fetchFromGitHub {
    owner = "aleho";
    repo = "gnome-shell-volume-mixer";
    rev = version;
    sha256 = "1s80w5csv82hxky33ql734z9df8zkg1r8xmxc9hl759z6rbqml9g";
  };

  patches = [
    ./find_libpulse.patch
  ];

  buildInputs = [
    glib
    pulseaudio
    python3
  ];

  postPatch = ''
    substituteInPlace ./shell-volume-mixer@derhofbauer.at/pautils/pa.py \
        --subst-var-by pulseaudio ${pulseaudio}
  '';

  # Could use the Makefile, but it requires npm...
  buildPhase = ''
    glib-compile-schemas --targetdir=${uuid}/schemas ${uuid}/schemas
  '';

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r ${uuid} $out/share/gnome-shell/extensions/
  '';

  uuid = "shell-volume-mixer@derhofbauer.at";

  meta = with stdenv.lib; {
    description = "GNOME Shell Extension allowing separate configuration of PulseAudio devices";
    license = licenses.gpl2;
    maintainers = with maintainers; [ bjornfor ];
    homepage = https://github.com/aleho/gnome-shell-volume-mixer;
  };
}
