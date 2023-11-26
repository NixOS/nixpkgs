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
  version = "4.8.1";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "libqalculate";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-4WqKlwVf4/ixVr98lPFVfNL6EOIfHHfL55xLsYqxkhY=";
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
