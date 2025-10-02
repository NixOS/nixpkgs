{
  lib,
  stdenv,
  fetchFromGitHub,
  faust2jaqt,
  faust2lv2,
}:
stdenv.mkDerivation rec {
  pname = "Tambura";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "olilarkin";
    repo = "Tambura";
    rev = "v${version}";
    sha256 = "1w80cmiyzca1wirf5gypg3hcix1ky777id8wnd3k92mn1jf4a24y";
  };

  buildInputs = [
    faust2jaqt
    faust2lv2
  ];

  dontWrapQtApps = true;

  buildPhase = ''
    faust2jaqt -vec -time -t 99999 Tambura.dsp
    faust2lv2 -vec -time -gui -t 99999 Tambura.dsp
  '';

  installPhase = ''
    mkdir -p $out/bin
    for f in $(find . -executable -type f); do
      cp $f $out/bin/
    done
    mkdir -p $out/lib/lv2
    cp -r Tambura.lv2/ $out/lib/lv2
  '';

  meta = with lib; {
    description = "FAUST patch inspired by the Indian Tambura/Tanpura - a four string drone instrument, known for its unique rich harmonic timbre";
    homepage = "https://github.com/olilarkin/Tambura";
    license = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
  };
}
