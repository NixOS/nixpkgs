{ lib
, stdenv
, doxygen
, fetchFromGitHub
, meson
, ninja
, pcre
, pkg-config
, python3
, serd
}:

stdenv.mkDerivation rec {
  pname = "sord";
  version = "0.16.14";

  src = fetchFromGitHub {
    owner = "drobilla";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-S22Szpg6iXeana5t6EpbOtRstthgrJ4Z2cBrf7a9ZBk=";
  };

  nativeBuildInputs = [
    doxygen
    meson
    ninja
    pkg-config
    python3
  ];
  buildInputs = [ pcre ];
  propagatedBuildInputs = [ serd ];

  doCheck = true;

  meta = with lib; {
    homepage = "http://drobilla.net/software/sord";
    description = "A lightweight C library for storing RDF data in memory";
    license = with licenses; [ bsd0 isc ];
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
