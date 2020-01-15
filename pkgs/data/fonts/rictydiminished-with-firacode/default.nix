{ stdenv, fetchgit, fontforge, pythonFull }:

stdenv.mkDerivation rec {
  pname = "rictydiminished-with-firacode";
  version = "0.0.1";
  src = fetchgit {
    url = "https://github.com/hakatashi/RictyDiminished-with-FiraCode.git";
    rev = "refs/tags/${version}";
    sha256 = "12lhb0k4d8p4lzw9k6hlsxpfpc15zfshz1h5cbaa88sb8n5jh360";
    fetchSubmodules = true;
  };

  buildPhase = ''
    substituteInPlace apply-feature.py --replace \
      'ricty = ttLib.TTFont(options.in_font)' \
      'ricty = ttLib.TTFont(options.in_font, recalcTimestamp=False)'
    substituteInPlace build-py3.py --replace \
      'datetime.date.today()' \
      'datetime.date.fromtimestamp(float(os.environ["SOURCE_DATE_EPOCH"]))'

    make
  '';

  installPhase = ''
    install -m444 -Dt $out/share/fonts/rictydiminished-with-firacode *.ttf
  '';

  nativeBuildInputs = [
    fontforge
    (pythonFull.withPackages (ps: [
      ps.jinja2
      ps.py3to2
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

