{
  fetchhg,
  lib,
  stdenv,
  cmake,
  coin3d,
  motif,
  libXext,
  libXmu,
  libGLU,
  libGL,
}:

stdenv.mkDerivation {
  pname = "soxt";
  version = "unstable-2019-06-14";

  src = fetchhg {
    url = "https://bitbucket.org/Coin3D/soxt";
    rev = "85e135bb266fbb17e47fc336b876a576a239c15c";
    sha256 = "0vk5cgn53yqf7csqdnlnyyhi4mbgx4wlsq70613p5fgxlvxzhcym";
    fetchSubrepos = true;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    coin3d
    motif
    libGLU
    libGL
    libXext
    libXmu
  ];

  meta = with lib; {
    homepage = "https://bitbucket.org/Coin3D/coin/wiki/Home";
    license = licenses.bsd3;
    description = "A GUI binding for using Open Inventor with Xt/Motif";
    maintainers = with maintainers; [ tmplt ];
    platforms = platforms.linux;
  };
}
