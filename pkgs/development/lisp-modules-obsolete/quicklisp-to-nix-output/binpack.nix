/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "binpack";
  version = "20201220-git";

  parasites = [ "binpack/2" ];

  description = "Rectangle packer for sprite/texture atlases";

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/binpack/2020-12-20/binpack-20201220-git.tgz";
    sha256 = "1kyl19kjsii2nrbf229c5fb3bjw7r25736f991g2j8vig991imwm";
  };

  packageName = "binpack";

  asdFilesToKeep = ["binpack.asd"];
  overrides = x: x;
}
/* (SYSTEM binpack DESCRIPTION Rectangle packer for sprite/texture atlases
    SHA256 1kyl19kjsii2nrbf229c5fb3bjw7r25736f991g2j8vig991imwm URL
    http://beta.quicklisp.org/archive/binpack/2020-12-20/binpack-20201220-git.tgz
    MD5 1ac4eaa76586091edb77111ea033f316 NAME binpack FILENAME binpack DEPS
    ((NAME alexandria FILENAME alexandria)) DEPENDENCIES (alexandria) VERSION
    20201220-git SIBLINGS (binpack-test) PARASITES (binpack/2)) */
