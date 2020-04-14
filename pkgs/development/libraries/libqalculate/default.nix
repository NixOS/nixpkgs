{ stdenv, fetchFromGitHub, mpfr, libxml2, intltool, pkgconfig, doxygen,
  autoreconfHook, readline, libiconv, icu, curl, gnuplot, gettext }:

stdenv.mkDerivation rec {
  pname = "libqalculate";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "libqalculate";
    rev = "v${version}";
    sha256 = "0yjig8l4dwpi4ms96yg63z6ag0s38fpific05h5pj37s3gyhv24m";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ intltool pkgconfig autoreconfHook doxygen ];
  buildInputs = [ curl gettext libiconv readline ];
  propagatedBuildInputs = [ libxml2 mpfr icu ];
  enableParallelBuilding = true;

  preConfigure = ''
    intltoolize -f
  '';

  patchPhase = ''
    substituteInPlace libqalculate/Calculator-plot.cc \
      --replace 'commandline = "gnuplot"' 'commandline = "${gnuplot}/bin/gnuplot"' \
      --replace '"gnuplot - ' '"${gnuplot}/bin/gnuplot - '
  '' + stdenv.lib.optionalString stdenv.cc.isClang ''
    substituteInPlace src/qalc.cc \
      --replace 'printf(_("aborted"))' 'printf("%s", _("aborted"))'
  '';

  preBuild = ''
    pushd docs/reference
    doxygen Doxyfile
    popd
  '';

  meta = with stdenv.lib; {
    description = "An advanced calculator library";
    homepage = "http://qalculate.github.io";
    maintainers = with maintainers; [ gebner ];
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
