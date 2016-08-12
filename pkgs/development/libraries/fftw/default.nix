{ fetchFromGitHub , stdenv, lib, ocaml, perl, indent, transfig, ghostscript, texinfo, libtool, gettext, automake, autoconf, precision ? "double" }:

with lib;

assert elem precision [ "single" "double" "long-double" "quad-precision" ];

let version = "3.3.5-rc1"; in

stdenv.mkDerivation rec {
  name = "fftw-${precision}-${version}";

  src = fetchFromGitHub {
    owner = "FFTW";
    repo = "fftw3";
    rev = "fftw-${version}";
    sha256 = "1gc57xvdqbapq30ylj3fxwkv61la4kzyf7ji0q0xqjwpji2ynqi4";
  };

  nativeBuildInputs = [ ocaml perl indent transfig ghostscript texinfo libtool gettext automake autoconf ];

  # remove the ./configure lines, so we can use nix's configureFlags
  patchPhase = "sed -e '27,29d' -i bootstrap.sh";

  preConfigurePhases =  "./bootstrap.sh";

  outputs = [ "dev" "out" "doc" ]; # it's dev-doc only
  outputBin = "dev"; # fftw-wisdom

  configureFlags =
    [ "--enable-maintainer-mode"
      "--enable-shared" "--disable-static"
      "--enable-threads"
    ]
    ++ optional (precision != "double") "--enable-${precision}"
    # all x86_64 have sse2
    # however, not all float sizes fit
    ++ optional (stdenv.isx86_64 && (precision == "single" || precision == "double") )  "--enable-sse2"
    ++ optional stdenv.cc.isGNU "--enable-openmp";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Fastest Fourier Transform in the West library";
    homepage = http://www.fftw.org/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.unix;
  };
}
