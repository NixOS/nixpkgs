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
    substituteInPlace apply-feature.py --replace \
      'ricty = ttLib.TTFont(options.in_font)' \
      'ricty = ttLib.TTFont(options.in_font, recalcTimestamp=False)'
    substituteInPlace build-py3.py --replace \
      'datetime.date.today()' \
      'datetime.date.fromtimestamp(float(os.environ["SOURCE_DATE_EPOCH"]))'

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
      ps.py3to2
      ps.fonttools
    ]))
  ];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "09ldviapljn4bb1mcxap2pkz7cq3wr2k2qialbnav5y7ii82acd4";

  meta = with stdenv.lib; {
    homepage = https://github.com/hakatashi/RictyDiminished-with-FiraCode;
    description = "The best Japanese programming font meets the awesone ligatures of Firacode";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ mt-caret ];
  };
}

