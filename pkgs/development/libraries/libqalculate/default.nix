{ lib, stdenv, fetchFromGitHub
, mpfr, gnuplot
, readline
, libxml2, curl
, intltool, libiconv, icu, gettext
, pkg-config, doxygen, autoreconfHook, buildPackages
}:

stdenv.mkDerivation rec {
  pname = "libqalculate";
  version = "4.5.1";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "libqalculate";
    rev = "v${version}";
    sha256 = "sha256-ipnWrh3L+wp6Qaw9UQVBVHLJvzrpyPFnKbi0U5zlxWU=";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ intltool pkg-config autoreconfHook doxygen ];
  buildInputs = [ curl gettext libiconv readline ];
  depsBuildBuild = [ buildPackages.stdenv.cc ];
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
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ gebner doronbehar alyaeanyx ];
    mainProgram = "qalc";
    platforms = platforms.all;
  };
}
