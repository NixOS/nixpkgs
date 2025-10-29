{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  alcotest,
  pkg-config,
  dune-configurator,
}:

buildDunePackage rec {
  pname = "bigstringaf";
  version = "0.10.0";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = pname;
    tag = version;
    hash = "sha256-p1hdB3ArOd2UX7S6YvXCFbYjEiXdMDmBaC/lFQgua7Q=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];

  checkInputs = [ alcotest ];
  doCheck = true;

  meta = {
    description = "Bigstring intrinsics and fast blits based on memcpy/memmove";
    longDescription = ''
      Bigstring intrinsics and fast blits based on memcpy/memmove

      The OCaml compiler has a bunch of intrinsics for Bigstrings, but they're not
      widely-known, sometimes misused, and so programs that use Bigstrings are slower
      than they have to be. And even if a library got that part right and exposed the
      intrinsics properly, the compiler doesn't have any fast blits between
      Bigstrings and other string-like types.

      So here they are. Go crazy.
    '';
    changelog = "https://github.com/inhabitedtype/bigstringaf/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
