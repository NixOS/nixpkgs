{ lib, stdenv, fetchFromGitHub, python39 }:

stdenv.mkDerivation {
  pname = "monoid";
  version = "2020-10-26";

  src = fetchFromGitHub {
    owner = "larsenwork";
    repo = "monoid";
    rev = "0673c8d6728df093faee9f183b6dfa62939df8c0";
    sha256 = "sha256-u2jwVOC9QM2JHsdAVBuEpqqdiBAVs+IWnpp48A5Xk28=";
  };

  nativeBuildInputs = [
    (python39.withPackages (pp: with pp; [
      fontforge
    ]))
  ];

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

  meta = with lib; {
    homepage = "http://larsenwork.com/monoid";
    description = "Customisable coding font with alternates, ligatures and contextual positioning";
    license = [ licenses.ofl licenses.mit ];
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}

