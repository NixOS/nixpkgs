{ stdenv, fetchFromGitHub, python, fontforge }:

stdenv.mkDerivation rec {
  name = "monoid-${version}";
  version = "0.61";

  src = fetchFromGitHub {
    owner = "larsenwork";
    repo = "monoid";
    rev = "0.61";
    sha256 = "1h18r93klpsc0h744cnlx6ca7p790k427j0lq0y4gnhcbw14zr4f";
  };

  nativeBuildInputs = [ python fontforge ];

  buildPhase = ''
    local _d=""
    local _l=""
    for _d in {Monoisome,Source}/*.sfdir; do
      _l="''${_d##*/}.log"
      echo "Building $_d (log at $_l)"
      python Scripts/build.py 1 0 $_d > $_l
    done
  '';

  installPhase = ''
    install -m444 -Dt $out/share/fonts/truetype _release/*
    install -m444 -Dt $out/share/doc            Readme.md
  '';

  meta = with stdenv.lib; {
    description = "Customisable coding font with alternates, ligatures and contextual positioning";
    homepage = "http://larsenwork.com/monoid";
    license = [ licenses.ofl licenses.mit ];
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
