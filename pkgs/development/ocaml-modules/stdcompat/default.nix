{
  buildDunePackage,
  ocaml,
  lib,
  fetchurl,
}:

buildDunePackage rec {
  pname = "stdcompat";
  version = "21.1";

  minimalOCamlVersion = "4.11";

  src = fetchurl {
    url = "https://github.com/ocamllibs/stdcompat/archive/refs/tags/${version}.tar.gz";
    sha256 = "sha256-RSJ9AgUEmt23QZCk60ETIXmkJhG7knQe+s8wNxxIHm4=";
  };

  # Otherwise ./configure script will run and create files conflicting with dune.
  dontConfigure = true;

  meta = {
    homepage = "https://github.com/ocamllibs/stdcompat";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
    broken = lib.versionAtLeast ocaml.version "5.4";
  };
}
