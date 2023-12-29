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

let
  emilua-http-wrap = fetchFromGitHub {
      owner = "BoostGSoC14";
      repo = "boost.http";
      rev = "93ae527c89ffc517862e1f5f54c8a257278f1195";
      name = "emilua-http";
      hash = "sha256-MN29YwkTi0TJ2V+vRI9nUIxvJKsG+j3nT3o0yQB3p0o=";
  };

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
  version = "0.4.3";

  src = fetchFromGitLab {
      owner = "emilua";
      repo = "emilua";
      rev = "v${version}";
      hash = "sha256-vZITPQ1qUHhw24c0HKdR6VenviOc6JizQQ8w7K94irc=";
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
  ];

  nativeBuildInputs = [
    re2c
    gperf
    gawk
    xxd
    pkg-config
    asciidoctor
    meson
    ninja
  ];

  # Meson is no longer able to pick up Boost automatically.
  # https://github.com/NixOS/nixpkgs/issues/86131
  env = {
    BOOST_INCLUDEDIR = "${lib.getDev boost182}/include";
    BOOST_LIBRARYDIR = "${lib.getLib boost182}/lib";
  };

  mesonFlags = [
    "-Dversion_suffix=-nixpkgs1"
    "-Denable_http=true"
    "-Denable_file_io=true"
    "-Denable_io_uring=true"
    "-Denable_linux_namespaces=true"
    "-Denable_tests=true"
    "-Denable_manpages=true"
  ];

  postPatch = ''
    pushd subprojects
    cp -r ${emilua-http-wrap} emilua-http
    cp -r ${trial-protocol-wrap} trial-protocol
    chmod +w emilua-http trial-protocol
    cp "packagefiles/emilua-http/meson.build" "emilua-http/"
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
