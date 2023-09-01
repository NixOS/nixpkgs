{ lib
, stdenv
, meson
, ninja
, fetchFromGitHub
, fetchFromGitLab
, re2c
, gperf
, gawk
, xxd
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
, asciidoctor
}:

stdenv.mkDerivation rec {
  pname = "emilua";
  version = "0.4.3";

  srcs = [
    (fetchFromGitLab {
      owner = "emilua";
      repo = "emilua";
      rev = "v${version}";
      name = pname;
      sha256 = "vZITPQ1qUHhw24c0HKdR6VenviOc6JizQQ8w7K94irc=";
      fetchSubmodules = false;
    })
    (fetchFromGitHub {
      owner = "BoostGSoC14";
      repo = "boost.http";
      rev = "93ae527c89ffc517862e1f5f54c8a257278f1195";
      name = "emilua-http";
      sha256 = "MN29YwkTi0TJ2V+vRI9nUIxvJKsG+j3nT3o0yQB3p0o=";
      fetchSubmodules = false;
    })
    (fetchFromGitHub {
      owner = "breese";
      repo = "trial.protocol";
      rev = "79149f604a49b8dfec57857ca28aaf508069b669";
      name = "trial-protocol";
      sha256 = "Xd8bX3z9PZWU17N9R95HXdj6qo9at5FBL/+PTVaJgkw=";
      fetchSubmodules = false;
    })
  ];

  sourceRoot = ".";

  buildInputs = [
    luajit_openresty
    re2c
    gperf
    gawk
    xxd
    pkg-config
    asciidoctor
  ];

  nativeBuildInputs = [
    boost182
    fmt
    luajit_openresty
    ncurses
    serd
    sord
    libcap
    liburing
    openssl
    meson
    ninja
  ];

  # Meson is no longer able to pick up Boost automatically.
  # https://github.com/NixOS/nixpkgs/issues/86131
  BOOST_INCLUDEDIR = "${lib.getDev boost182}/include";
  BOOST_LIBRARYDIR = "${lib.getLib boost182}/lib";

  mesonFlags = [
    "-Dversion_suffix=-nix1"
    "-Denable_http=true"
    "-Denable_file_io=true"
    "-Denable_io_uring=true"
    "-Denable_linux_namespaces=true"
    "-Denable_tests=true"
    "-Denable_manpages=true"
  ];

  postUnpack = ''mv emilua-http emilua/
  mv trial-protocol emilua/
  substituteInPlace emilua/src/emilua_gperf.awk  --replace '#!/usr/bin/env -S gawk --file' '#!${gawk}/bin/gawk -f'
  cd emilua/subprojects
  ln -s ../emilua-http .
  cp "packagefiles/emilua-http/meson.build" "emilua-http/"
  ln -s ../trial-protocol .
  cp "packagefiles/trial.protocol/meson.build" "trial-protocol/"
  cd ..
  '';

  meta = with lib; = {
    description = "Lua execution engine";
    homepage = "https://gitlab.com/emilua/emilua";
    license = licenses.boost;
    maintainers = with maintainers; [ manipuladordedados ];
    platforms = platforms.linux;
  };