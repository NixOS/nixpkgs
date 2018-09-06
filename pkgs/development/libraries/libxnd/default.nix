{ lib
, stdenv
, fetchFromGitHub
, libndtypes
}:

stdenv.mkDerivation rec {
  name = "libxnd-${version}";
  version = "0.2.0dev3";

  src = fetchFromGitHub {
    owner = "plures";
    repo = "xnd";
    rev = "v${version}";
    sha256 = "0byq7jspyr2wxrhihw4q7nf0y4sb6j5ax0ndd5dnq5dz88c7qqm2";
  };

  buildInputs = [ libndtypes ];

  configureFlags = [ "XND_INCLUDE='-I${libndtypes}/include'"
                     "XND_LINK='-L${libndtypes}/lib'" ];

  makeFlags = [ "CONFIGURE_LDFLAGS='-shared'" ];

  meta = {
    description = "General container that maps a wide range of Python values directly to memory";
    homepage = https://xnd.io/;
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
