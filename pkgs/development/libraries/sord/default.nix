{
  lib,
  stdenv,
  doxygen,
  fetchFromGitHub,
  meson,
  ninja,
  pcre2,
  pkg-config,
  python3,
  serd,
  zix,
}:

stdenv.mkDerivation rec {
  pname = "sord";
  version = "0.16.16";

  src = fetchFromGitHub {
    owner = "drobilla";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GDs1m8KoEhJDdCf7kacQMZzCNPoZhESJds6KupQvOkU=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
    "man"
  ];

  nativeBuildInputs = [
    doxygen
    meson
    ninja
    pkg-config
    python3
  ];
  buildInputs = [ pcre2 ];
  propagatedBuildInputs = [
    serd
    zix
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "http://drobilla.net/software/sord";
    description = "A lightweight C library for storing RDF data in memory";
    license = with licenses; [
      bsd0
      isc
    ];
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
