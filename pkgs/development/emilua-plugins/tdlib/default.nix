{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchFromGitHub,
  gperf,
  gawk,
  gitUpdater,
  pkg-config,
  boost,
  luajit_openresty,
  asciidoctor,
  emilua,
  liburing,
  openssl,
  cmake,
  fmt,
  zlib,
}:

let
  td-wrap = fetchFromGitHub {
    owner = "tdlib";
    repo = "td";
    rev = "4041ecb535802ba1c55fcd11adf5d3ada41c2be7";
    hash = "sha256-/TaPYy+FUOVhyocDZ13zwR07xbzp6g8c6xvAGVFLQvk=";
  };

  trial-circular-wrap = fetchFromGitHub {
    owner = "breese";
    repo = "trial.protocol";
    rev = "79149f604a49b8dfec57857ca28aaf508069b669";
    hash = "sha256-Xd8bX3z9PZWU17N9R95HXdj6qo9at5FBL/+PTVaJgkw=";
  };
in
stdenv.mkDerivation rec {
  pname = "emilua-tdlib";
  version = "1.0.3";

  src = fetchFromGitLab {
    owner = "emilua";
    repo = "tdlib";
    rev = "v${version}";
    hash = "sha256-14jg71m1za+WW0PP9cg1XniCupl9/RXqeEP1SE+62Ng=";
    fetchSubmodules = true;
  };

  buildInputs = [
    emilua
    liburing
    fmt
    luajit_openresty
    openssl
    boost
    td-wrap
    trial-circular-wrap
  ];

  nativeBuildInputs = [
    gperf
    gawk
    pkg-config
    asciidoctor
    cmake
    zlib
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-warn 'pkg_get_variable(EMILUA_PLUGINSDIR emilua pluginsdir)' 'set(EMILUA_PLUGINSDIR "${"$"}{CMAKE_INSTALL_PREFIX}/${emilua.sitePackages}")'
  '';

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = with lib; {
    description = "Telegram Database Library bindings for Emilua";
    homepage = "https://emilua.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ manipuladordedados ];
    platforms = platforms.linux;
  };
}
