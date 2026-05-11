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
    sha256 = "0sl7lnjr2l4c2f7qaazvpwpzsp4gckkvccfam88wcq9f7j9xxbyp";
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
