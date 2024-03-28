{ lib, stdenv, fetchFromGitHub, cmake, boost, glog, leveldb, marisa, opencc,
  yaml-cpp, gtest, capnproto, pkg-config, xorgproto, utf8cpp, plugins ? [ ] }:

let
  copySinglePlugin = plug: "cp -r ${plug} plugins/${plug.name}";
  copyPlugins = ''
    mkdir -p plugins
    ${lib.concatMapStringsSep "\n" copySinglePlugin plugins}
    chmod +w -R plugins/*
  '';
in
stdenv.mkDerivation rec {
  pname = "librime";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "rime";
    repo = pname;
    rev = version;
    sha256 = "sha256-tflWBfH1+1AFvkq0A6mgsKl+jq6m5c83GA56LWxdnlw=";
  };

  nativeBuildInputs = [ cmake pkg-config utf8cpp ];

  buildInputs = [ boost glog leveldb marisa opencc yaml-cpp gtest capnproto
                  xorgproto ]
              ++ plugins; # for propagated build inputs

  strictDeps = true;

  postPatch = ''
    rm --recursive --verbose include/{utf8,utf8.h,X11}
  '';


  preConfigure = copyPlugins;

  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS='-I${lib.getDev utf8cpp}/include/utf8cpp'"
  ];

  meta = with lib; {
    homepage    = "https://rime.im/";
    description = "Rime Input Method Engine, the core library";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ vonfry ];
    platforms   = platforms.linux ++ platforms.darwin;
  };
}
