/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "glsl-spec";
  version = "release-quicklisp-f04476f7-git";

  description = "The GLSL Spec as a datastructure";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/glsl-spec/2019-10-07/glsl-spec-release-quicklisp-f04476f7-git.tgz";
    sha256 = "0vdxx5asra0r58qpk35ncmyh418szzzvby8bpkrb052g00nzqgj7";
  };

  packageName = "glsl-spec";

  asdFilesToKeep = ["glsl-spec.asd"];
  overrides = x: x;
}
/* (SYSTEM glsl-spec DESCRIPTION The GLSL Spec as a datastructure SHA256
    0vdxx5asra0r58qpk35ncmyh418szzzvby8bpkrb052g00nzqgj7 URL
    http://beta.quicklisp.org/archive/glsl-spec/2019-10-07/glsl-spec-release-quicklisp-f04476f7-git.tgz
    MD5 52760939a269acce6b2cba8dbde81ef7 NAME glsl-spec FILENAME glsl-spec DEPS
    NIL DEPENDENCIES NIL VERSION release-quicklisp-f04476f7-git SIBLINGS
    (glsl-docs glsl-symbols) PARASITES NIL) */
