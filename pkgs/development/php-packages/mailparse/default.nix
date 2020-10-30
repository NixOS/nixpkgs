{ buildPecl, lib, php }:

buildPecl {
  pname = "mailparse";

  version = "3.1.1";
  sha256 = "02nfjbgyjbr48rw6r46gd713hkxh7nghg2rcbr726zhzz182c3y7";

  internalDeps = [ php.extensions.mbstring ];
  postConfigure = ''
    echo "#define HAVE_MBSTRING 1" >> config.h
  '';

  meta.maintainers = lib.teams.php.members;
}
