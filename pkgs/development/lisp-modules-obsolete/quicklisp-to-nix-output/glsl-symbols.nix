/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "glsl-symbols";
  version = "glsl-spec-release-quicklisp-f04476f7-git";

  description = "Lispy versions of all glsl names as symbols";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/glsl-spec/2019-10-07/glsl-spec-release-quicklisp-f04476f7-git.tgz";
    sha256 = "0vdxx5asra0r58qpk35ncmyh418szzzvby8bpkrb052g00nzqgj7";
  };

  packageName = "glsl-symbols";

  asdFilesToKeep = ["glsl-symbols.asd"];
  overrides = x: x;
}
/* (SYSTEM glsl-symbols DESCRIPTION Lispy versions of all glsl names as symbols
    SHA256 0vdxx5asra0r58qpk35ncmyh418szzzvby8bpkrb052g00nzqgj7 URL
    http://beta.quicklisp.org/archive/glsl-spec/2019-10-07/glsl-spec-release-quicklisp-f04476f7-git.tgz
    MD5 52760939a269acce6b2cba8dbde81ef7 NAME glsl-symbols FILENAME
    glsl-symbols DEPS NIL DEPENDENCIES NIL VERSION
    glsl-spec-release-quicklisp-f04476f7-git SIBLINGS (glsl-docs glsl-spec)
    PARASITES NIL) */
