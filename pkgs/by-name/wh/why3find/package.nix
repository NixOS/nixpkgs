{
  lib,
  fetchurl,
  ocamlPackages,
  why3,
}:

with ocamlPackages;
buildDunePackage {
  pname = "why3find";
  version = "1.2.0";

  src = fetchurl {
    url = "https://git.frama-c.com/-/project/1056/uploads/043312a7a70961338479016ac535c706/why3find-1.2.0.tbz";
    hash = "sha256-eslkMBo0i0+Oy8jW9eRNuyGXuwkV6eeYcxZm5MfgA6w=";
  };

  propagatedBuildInputs = [
    dune-site
    terminal_size
    why3
    yojson
    zmq
  ];

  meta = {
    description = "Why3 Package Manager";
    homepage = "https://git.frama-c.com/pub/why3find";
    license = lib.licenses.lgpl21Only;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
