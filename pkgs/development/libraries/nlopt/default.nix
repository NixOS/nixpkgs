{ stdenv, fetchFromGitHub, cmake, octave ? null }:

stdenv.mkDerivation rec {
  pname = "nlopt";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "stevengj";
    repo = pname;
    rev = "v${version}";
    sha256 = "0maxvarvd4x0bg11qrb98zk9kw55qi474p8javfrkrbmc3xl31y6";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ octave ];

  configureFlags = [
    "--with-cxx"
    "--enable-shared"
    "--with-pic"
    "--without-guile"
    "--without-python"
    "--without-matlab"
  ] ++ stdenv.lib.optionals (octave != null) [
    "--with-octave"
    "M_INSTALL_DIR=$(out)/${octave.sitePath}/m"
    "OCT_INSTALL_DIR=$(out)/${octave.sitePath}/oct"
  ];

  meta = {
    homepage = "https://nlopt.readthedocs.io/en/latest/";
    description = "Free open-source library for nonlinear optimization";
    license = stdenv.lib.licenses.lgpl21Plus;
    hydraPlatforms = stdenv.lib.platforms.linux;
  };

}
