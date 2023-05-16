{ lib, stdenv, fetchFromGitHub
, mpfr, gnuplot
, readline
, libxml2, curl
, intltool, libiconv, icu, gettext
, pkg-config, doxygen, autoreconfHook, buildPackages
}:

stdenv.mkDerivation rec {
  pname = "libqalculate";
<<<<<<< HEAD
  version = "4.8.0";
=======
  version = "4.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "libqalculate";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-wONqqd8Ds10SvkUrj7Ps6BfqUNPE6hCnQrKDTEglVEQ=";
=======
    sha256 = "sha256-GOVSNEnEl/oef54q88s+YuLyqPMLyx1eoX7DlWrmo2c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
