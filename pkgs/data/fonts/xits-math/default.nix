{ stdenv, fetchFromGitHub, python2Packages, fontforge }:

stdenv.mkDerivation rec {
  name = "xits-math-${version}";
  version = "1.108";

  src = fetchFromGitHub {
    owner = "khaledhosny";
    repo = "xits-math";
    rev = "v${version}";
    sha256 = "08nn676c41a7gmmhrzi8mm0g74z8aiaafjk48pqcwxvjj9av7xjg";
  };

  nativeBuildInputs = [ fontforge ] ++ (with python2Packages; [ python fonttools ]);

  postPatch = ''
    rm *.otf

    substituteInPlace tools/postprocess.py --replace \
      'font = ttLib.TTFont(sys.argv[1])' \
      'font = ttLib.TTFont(sys.argv[1], recalcTimestamp=False)'
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp *.otf $out/share/fonts/opentype
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "00xycmb9ka67j5s66nkng53y8q6362igisxz04zb58r2717jk50m";

  meta = with stdenv.lib; {
    homepage = https://github.com/khaledhosny/xits-math;
    description = "OpenType implementation of STIX fonts with math support";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  };
}
