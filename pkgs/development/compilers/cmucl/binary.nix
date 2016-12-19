{stdenv, fetchurl}:

let
  inherit (stdenv) system;
  version = "21a";
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
        sha256 = "0w8dcaiasfd4fbj340zaf6wcjfgc4wzkvr24gbxa5rr3aw10rl02";
      }
    else throw "Unsupported platform for cmucl.";
in

stdenv.mkDerivation {
  name = "cmucl-binary-${version}";

  buildCommand = ''
    mkdir -p $out
    tar -C $out -xjf ${dist}
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/bin/lisp
  '';

  meta = {
    description = "The CMU implementation of Common Lisp";
    longDescription = ''
      CMUCL is a free implementation of the Common Lisp programming language
      which runs on most major Unix platforms.  It mainly conforms to the
      ANSI Common Lisp standard.
    '';
    license = stdenv.lib.licenses.free;		# public domain
    homepage = http://www.cons.org/cmucl/;
    maintainers = [stdenv.lib.maintainers.tohl];
    platforms = stdenv.lib.platforms.linux;
  };
}
