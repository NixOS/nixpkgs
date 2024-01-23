{ lib
, stdenv
, meson
, ninja
, fetchFromGitHub
, fetchFromGitLab
, re2c
, gperf
, gawk
, pkg-config
, boost182
, fmt
, luajit_openresty
, ncurses
, serd
, sord
, libcap
, liburing
, openssl
, cereal
, cmake
, asciidoctor
}:

let
  trial-protocol-wrap = fetchFromGitHub {
      owner = "breese";
      repo = "trial.protocol";
      rev = "79149f604a49b8dfec57857ca28aaf508069b669";
      name = "trial-protocol";
      hash = "sha256-Xd8bX3z9PZWU17N9R95HXdj6qo9at5FBL/+PTVaJgkw=";
  };
in
stdenv.mkDerivation rec {
  pname = "emilua";
  version = "0.6.0";

  src = fetchFromGitLab {
      owner = "emilua";
      repo = "emilua";
      rev = "v${version}";
      hash = "sha256-cW2b+jUQT60hCCirBzxZltzA7KvBihnzWNPkKDID6kU=";
  };

  buildInputs = [
    luajit_openresty
    boost182
    fmt
    ncurses
    serd
    sord
    libcap
    liburing
    openssl
    cereal
  ];

  nativeBuildInputs = [
    re2c
    gperf
    gawk
    pkg-config
    asciidoctor
    meson
    cmake
    ninja
  ];

  dontUseCmakeConfigure = true;

  # Meson is no longer able to pick up Boost automatically.
  # https://github.com/NixOS/nixpkgs/issues/86131
  env = {
    BOOST_INCLUDEDIR = "${lib.getDev boost182}/include";
    BOOST_LIBRARYDIR = "${lib.getLib boost182}/lib";
  };

  mesonFlags = [
    (lib.mesonBool "enable_file_io" true)
    (lib.mesonBool "enable_io_uring" true)
    (lib.mesonBool "enable_tests" true)
    (lib.mesonBool "enable_manpages" true)
    (lib.mesonOption "version_suffix" "-nixpkgs1")
  ];

  postPatch = ''
    pushd subprojects
    cp -r ${trial-protocol-wrap} trial-protocol
    chmod +w trial-protocol
    cp "packagefiles/trial.protocol/meson.build" "trial-protocol/"
    popd

    substituteInPlace src/emilua_gperf.awk  --replace '#!/usr/bin/env -S gawk --file' '#!${gawk}/bin/gawk -f'
  '';

  meta = with lib; {
    description = "Lua execution engine";
    homepage = "https://emilua.org/";
    license = licenses.boost;
    maintainers = with maintainers; [ manipuladordedados ];
    platforms = platforms.linux;
  };
}
