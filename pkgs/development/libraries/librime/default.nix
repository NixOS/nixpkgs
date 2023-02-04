{ lib, stdenv, fetchFromGitHub, cmake, boost, glog, leveldb, marisa, opencc,
  yaml-cpp, gtest, capnproto, pkg-config, plugins ? [ ] }:

let
  copySinglePlugin = plug: "cp -r ${plug} plugins/${plug.name}";
  copyPlugins = ''
    ${lib.concatMapStringsSep "\n" copySinglePlugin plugins}
    chmod +w -R plugins/*
  '';
in
stdenv.mkDerivation rec {
  pname = "librime";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "rime";
    repo = pname;
    rev = version;
    sha256 = "sha256-tPuDDVV4ZeBva/oHcw0rNjkzYmCtT2vLCdwCukBM28w=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ boost glog leveldb marisa opencc yaml-cpp gtest capnproto ]
              ++ plugins; # for propagated build inputs

  preConfigure = copyPlugins;

  meta = with lib; {
    homepage    = "https://rime.im/";
    description = "Rime Input Method Engine, the core library";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ vonfry ];
    platforms   = platforms.linux;
  };
}
