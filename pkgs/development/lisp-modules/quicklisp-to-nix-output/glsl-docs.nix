/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "glsl-docs";
  version = "glsl-spec-release-quicklisp-f04476f7-git";

  description = "The official docs for all the symbols in glsl-symbols";

  deps = [ args."glsl-symbols" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/glsl-spec/2019-10-07/glsl-spec-release-quicklisp-f04476f7-git.tgz";
    sha256 = "0vdxx5asra0r58qpk35ncmyh418szzzvby8bpkrb052g00nzqgj7";
  };

  packageName = "glsl-docs";

  asdFilesToKeep = ["glsl-docs.asd"];
  overrides = x: x;
}
/* (SYSTEM glsl-docs DESCRIPTION
    The official docs for all the symbols in glsl-symbols SHA256
    0vdxx5asra0r58qpk35ncmyh418szzzvby8bpkrb052g00nzqgj7 URL
    http://beta.quicklisp.org/archive/glsl-spec/2019-10-07/glsl-spec-release-quicklisp-f04476f7-git.tgz
    MD5 52760939a269acce6b2cba8dbde81ef7 NAME glsl-docs FILENAME glsl-docs DEPS
    ((NAME glsl-symbols FILENAME glsl-symbols)) DEPENDENCIES (glsl-symbols)
    VERSION glsl-spec-release-quicklisp-f04476f7-git SIBLINGS
    (glsl-spec glsl-symbols) PARASITES NIL) */
