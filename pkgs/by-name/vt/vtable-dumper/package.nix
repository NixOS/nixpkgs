{
  lib,
  stdenv,
  fetchFromGitHub,
  libelf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vtable-dumper";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "lvc";
    repo = "vtable-dumper";
    rev = finalAttrs.version;
    hash = "sha256-16/ekzwuYcYRqsoxtudkj1z9L7/7K4WPE4xQkaWlh2o=";
  };

  buildInputs = [ libelf ];
  makeFlags = [ "prefix=$(out)" ];

  meta = {
    homepage = "https://github.com/lvc/vtable-dumper";
    description = "Tool to list content of virtual tables in a C++ shared library";
    mainProgram = "vtable-dumper";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.all;
  };
})
