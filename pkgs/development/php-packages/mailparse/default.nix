{ buildPecl, lib, php }:

buildPecl {
  pname = "mailparse";

  version = "3.0.3";
  sha256 = "00nk14jbdbln93mx3ag691avc11ff94hkadrcv5pn51c6ihsxbmz";

  internalDeps = [ php.extensions.mbstring ];
  postConfigure = ''
    echo "#define HAVE_MBSTRING 1" >> config.h
  '';

  meta.maintainers = lib.teams.php.members;
}
