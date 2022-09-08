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
  version = "unstable-2022-09-08";

  # Commit picked in mitigation of https://github.com/drobilla/sord/issues/5
  src = fetchFromGitHub {
    owner = "drobilla";
    repo = pname;
    rev = "46111484e2c5b611a15a77e6142c59465bcfd643";
    hash = "sha256-7mPiwSApaHiRnG5zW7J/6CtjZv3QE4tmFs6h3G+q4Z0=";
    fetchSubmodules = true;
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

  meta = with lib; {
    homepage = "http://drobilla.net/software/sord";
    description = "A lightweight C library for storing RDF data in memory";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
