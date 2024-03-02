{ lib, stdenv, fetchpatch, fetchurl, bison, perl }:

let
  version = "0.0.6";
  debianRevision = "7";
  debianPatch = patchname: hash: fetchpatch {
    name = "${patchname}.patch";
    url = "https://sources.debian.org/data/main/b/bulletml/${version}-${debianRevision}/debian/patches/${patchname}.patch";
    sha256 = hash;
  };

  lib_src = fetchurl {
    url = "http://shinh.skr.jp/libbulletml/libbulletml-${version}.tar.bz2";
    sha256 = "0yda0zgj2ydgkmby5676f5iiawabxadzh5p7bmy42998sp9g6dvw";
  };

  cpp_src = fetchurl {
    url = "http://shinh.skr.jp/d/d_cpp.tar.bz2";
    sha256 = "1ly9qmbb8q9nyadmdap1gmxs3vkniqgchlv2hw7riansz4gg1agh";
  };
in

stdenv.mkDerivation {
  pname = "bulletml";
  inherit version;

  srcs = [ lib_src cpp_src ];

  postUnpack = "mv d_cpp bulletml/";
  sourceRoot = "bulletml";

  patches = [
    (debianPatch "fixes" "0cnr968n0h50fjmjijx7idsa2pg2pv5cwy6nvfbkx9z8w2zf0mkl")
    (debianPatch "bulletml_d" "03d1dgln3gkiw019pxn3gwgjkmvzisq8kp3n6fpn38yfwh4fp4hv")
    (debianPatch "d_cpp" "04g9c7c89w7cgrxw75mcbdhzxqmz1716li49mhl98znakchrlb9h")
    (debianPatch "warnings" "18px79x4drvm6dy6w6js53nzlyvha7qaxhz5a99b97pyk3qc7i9g")
    (debianPatch "makefile" "0z6yxanxmarx0s08gh12pk2wfqjk8g797wmfcqczdv1i6xc7nqzp")
    (debianPatch "includes" "1n11j5695hs9pspslf748w2cq5d78s6bwhyl476wp6gcq6jw20bw")
  ];

  makeFlags = [
    "-C src"
  ];
  nativeBuildInputs = [ bison perl ];
  hardeningDisable = [ "format" ];

  installPhase = ''
    install -D -m 644 src/bulletml.d "$out"/include/d/bulletml.d
    install -d "$out"/include/bulletml/tinyxml
    install -m 644 src/*.h "$out"/include/bulletml
    install -m 644 src/tinyxml/tinyxml.h "$out"/include/bulletml/tinyxml
    cp -r src/boost $out/include/boost

    install -d "$out"/lib
    install -m 644 src/libbulletml.{a,so}* "$out"/lib

    install -D -m 644 README "$out"/share/doc/libbulletml/README.jp
    install -m 644 README.en "$out"/share/doc/libbulletml
    install -m 644 README.bulletml "$out"/share/doc/libbulletml
    install -D -m 644 README "$out"/share/licenses/libbulletml/README.jp
    install -m 644 README.en "$out"/share/licenses/libbulletml
  '';

  meta = with lib; {
    description = "C++ library to handle BulletML easily";
    longDescription = ''
      BulletML is the Bullet Markup Language. BulletML can describe the barrage
      of bullets in shooting games.
    '';
    homepage = "http://www.asahi-net.or.jp/~cs8k-cyu/bulletml/index_e.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fgaz ];
    # See https://github.com/NixOS/nixpkgs/pull/35482
    # for some attempts in getting it to build on darwin
    platforms = platforms.linux;
  };
}
