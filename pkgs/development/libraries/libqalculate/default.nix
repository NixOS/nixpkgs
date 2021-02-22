{ lib, stdenv, fetchFromGitHub, mpfr, libxml2, intltool, pkg-config, doxygen,
  autoreconfHook, readline, libiconv, icu, curl, gnuplot, gettext }:

stdenv.mkDerivation rec {
  pname = "libqalculate";
  version = "3.16.1";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "libqalculate";
    rev = "v${version}";
    sha256 = "sha256-mTxxiyN4t84BD4bBysvsrvP7L+DNbP6sMlcNFg4eMF8=";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ intltool pkg-config autoreconfHook doxygen ];
  buildInputs = [ curl gettext libiconv readline ];
  configureFlags = ["--with-readline=${readline.dev}"];
  propagatedBuildInputs = [ libxml2 mpfr icu ];
  enableParallelBuilding = true;

  preConfigure = ''
    intltoolize -f
  '';

  patchPhase = ''
    substituteInPlace libqalculate/Calculator-plot.cc \
      --replace 'commandline = "gnuplot"' 'commandline = "${gnuplot}/bin/gnuplot"' \
      --replace '"gnuplot - ' '"${gnuplot}/bin/gnuplot - '
  '' + lib.optionalString stdenv.cc.isClang ''
    substituteInPlace src/qalc.cc \
      --replace 'printf(_("aborted"))' 'printf("%s", _("aborted"))'
  '';

  preBuild = ''
    pushd docs/reference
    doxygen Doxyfile
    popd
  '';

  meta = with lib; {
    description = "An advanced calculator library";
    homepage = "http://qalculate.github.io";
    maintainers = with maintainers; [ gebner ];
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
