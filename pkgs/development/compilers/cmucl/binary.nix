{stdenv, fetchurl}:

let
  inherit (stdenv) system;
  version = "20b";
  downloadUrl = arch:
    "http://common-lisp.net/project/cmucl/downloads/release/" +
    "${version}/cmucl-${version}-${arch}.tar.bz2";
  fetchDist = {arch, sha256}: fetchurl {
    url = downloadUrl arch;
    inherit sha256;
  };
  dist =
    if system == "i686-linux" then fetchDist {
        arch = "x86-linux";
        sha256 = "1s00r1kszk5zhmv7m8z5q2wcqjn2gn7fbqwji3hgnsdvbb1f3jdn";
      }
    else if system == "i686-darwin" then fetchDist {
        arch = "x86-darwin";
        sha256 = "0vd3zbp5zcp0hjd3y03k595hmri8hw884brjpwjiby3jpm3l40np";
      }
    else throw "Unsupported platform for cmucl.";
in

stdenv.mkDerivation {
  name = "cmucl-binary-${version}";

  buildCommand = ''
    mkdir -p $out
    tar -C $out -xjf ${dist}
    patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      $out/bin/lisp
  '';

  meta = {
    description = "The CMU implementation of Common Lisp";
    longDescription = ''
      CMUCL is a free implementation of the Common Lisp programming language
      which runs on most major Unix platforms.  It mainly conforms to the
      ANSI Common Lisp standard.
    '';
    license = "free";		# public domain
    homepage = http://www.cons.org/cmucl/;
  };
}
