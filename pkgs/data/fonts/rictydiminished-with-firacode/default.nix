{ stdenv, fetchgit, fontforge, pythonFull }:

stdenv.mkDerivation rec {
  name = "rictydiminished-with-firacode-${version}";
  version = "0.0.1";
  src = fetchgit {
    url = "https://github.com/hakatashi/RictyDiminished-with-FiraCode.git";
    rev = "refs/tags/${version}";
    sha256 = "12lhb0k4d8p4lzw9k6hlsxpfpc15zfshz1h5cbaa88sb8n5jh360";
    fetchSubmodules = true;
  };

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/rictydiminished-with-firacode
    cp *.ttf $out/share/fonts/rictydiminished-with-firacode
  '';

  nativeBuildInputs = [
    fontforge
    (pythonFull.withPackages (ps: [
      ps.jinja2
      ps."3to2"
      ps.fonttools
    ]))
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/hakatashi/RictyDiminished-with-FiraCode;
    description = "The best Japanese programming font meets the awesone ligatures of Firacode";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ mt-caret ];
  };
}

