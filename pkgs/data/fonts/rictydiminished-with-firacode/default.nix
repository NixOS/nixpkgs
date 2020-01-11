{ stdenv, fetchgit, fontforge, python2, python3 }:

stdenv.mkDerivation rec {
  pname = "rictydiminished-with-firacode";
  version = "1.2.0";

  src = fetchgit {
    url = "https://github.com/hakatashi/RictyDiminished-with-FiraCode.git";
    rev = version;
    sha256 = "1vlzx5dsx6j9d9q84pdnwcxjy7mr1sv8sacx0zgfxhxnj66n1gnn";
    fetchSubmodules = true;
  };

  postPatch = ''
    # Make builds more reproducible
    substituteInPlace apply-feature.py --replace \
      'ricty = ttLib.TTFont(options.in_font)' \
      'ricty = ttLib.TTFont(options.in_font, recalcTimestamp=False)'
    substituteInPlace build-py3.py --replace \
      'datetime.date.today()' \
      'datetime.date.fromtimestamp(float(os.environ["SOURCE_DATE_EPOCH"]))'
  '';

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/rictydiminished-with-firacode *.ttf

    runHook postInstall
  '';

  nativeBuildInputs = [
    # Python 3 not supported by parts of the build system
    # https://github.com/hakatashi/RictyDiminished-with-FiraCode/pull/3
    (fontforge.override {
      python = python2;
    })
    (python3.withPackages (ps: [
      ps.jinja2
      ps.py3to2
      ps.fonttools
    ]))
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/hakatashi/RictyDiminished-with-FiraCode";
    description = "The best Japanese programming font meets the awesone ligatures of Firacode";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ mt-caret ];
  };
}

