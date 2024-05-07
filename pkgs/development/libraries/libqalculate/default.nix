{ lib
, stdenv
, fetchFromGitHub
, intltool
, pkg-config
, doxygen
, autoreconfHook
, buildPackages
, curl
, gettext
, libiconv
, readline
, libxml2
, mpfr
, icu
, gnuplot
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libqalculate";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "libqalculate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-74P8jIeg0Pge+/U0cQsrEfE+P8upBAr8xSyLhB4zOVU=";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [
    intltool
    pkg-config
    autoreconfHook
    doxygen
  ];
  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  buildInputs = [
    curl
    gettext
    libiconv
    readline
  ];
  propagatedBuildInputs = [
    libxml2
    mpfr
    icu
  ];
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
})
