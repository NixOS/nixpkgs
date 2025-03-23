{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  react,
  result,
  uchar,
  uutf,
  uucp,
  uuseg,
}:

buildDunePackage rec {
  pname = "zed";
  version = "3.2.3";

  propagatedBuildInputs = [
    react
    result
    uchar
    uutf
    uucp
    uuseg
  ];

  src = fetchFromGitHub {
    owner = "ocaml-community";
    repo = pname;
    rev = version;
    sha256 = "sha256-lbhqjZxeUqHdd+yahRO+B6L2mc+h+4T2+qKVgWC2HY8=";
  };

  meta = {
    description = "Abstract engine for text edition in OCaml";
    longDescription = ''
      Zed is an abstract engine for text edition. It can be used to write text editors, edition widgets, readlines, ...

      Zed uses Camomile to fully support the Unicode specification, and implements an UTF-8 encoded string type with validation, and a rope datastructure to achieve efficient operations on large Unicode buffers. Zed also features a regular expression search on ropes.

      To support efficient text edition capabilities, Zed provides macro recording and cursor management facilities.
    '';
    homepage = "https://github.com/ocaml-community/zed";
    changelog = "https://github.com/ocaml-community/zed/blob/${version}/CHANGES.md";
    license = lib.licenses.bsd3;
    maintainers = [
      lib.maintainers.gal_bolle
    ];
  };
}
