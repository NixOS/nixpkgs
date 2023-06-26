{ lib
, stdenv
, fetchurl
, guile
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "guile-opengl";
  version = "0.2.0";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-uPCH7CiCPQmfuELDupQQS7BPqecIFmSHpHGYnhwXbGU=";
  };

  nativeBuildInputs = [
    pkg-config
    guile
  ];

  meta = with lib; {
    homepage = "https://www.gnu.org/software/guile-opengl/";
    description = "Guile bindings for the OpenGL graphics API";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.unix;
  };
}
