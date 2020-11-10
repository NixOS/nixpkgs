{ stdenv, fetchgit, fontforge, python3 }:

stdenv.mkDerivation rec {
  pname = "rictydiminished-with-firacode";
  version = "1.2.2";

  src = fetchgit {
    url = "https://github.com/hakatashi/RictyDiminished-with-FiraCode.git";
    rev = version;
    sha256 = "0khnbp1y5xrd77gfb2b19mzi3ll07im3d0rlbciwbq0cn347f25p";
    fetchSubmodules = true;
  };

  postPatch = ''
    # Make builds more reproducible
    substituteInPlace apply-feature.py --replace \
      'ricty = ttLib.TTFont(options.in_font)' \
      'ricty = ttLib.TTFont(options.in_font, recalcTimestamp=False)'
    substituteInPlace build.py --replace \
      'datetime.date.today()' \
      'datetime.date.fromtimestamp(float(os.environ["SOURCE_DATE_EPOCH"]))'
  '';

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/rictydiminished-with-firacode *.ttf

    runHook postInstall
  '';

  nativeBuildInputs = [
    (python3.withPackages (ps: [
      ps.jinja2
      ps.fonttools
      ps.fontforge
    ]))
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/hakatashi/RictyDiminished-with-FiraCode";
    description = "The best Japanese programming font meets the awesome ligatures of Firacode";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ mt-caret ];
  };
}

