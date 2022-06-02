{ lib, buildDunePackage, fetchFromGitHub, camomile, react, charInfo_width }:

buildDunePackage rec {
  pname = "zed";
  version = "3.1.0";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "ocaml-community";
    repo = pname;
    rev = version;
    sha256 = "04vr1a94imsghm98iigc35rhifsz0rh3qz2qm0wam2wvp6vmrx0p";
  };

  propagatedBuildInputs = [ charInfo_width react ];

  meta = {
    description = "Abstract engine for text edition in OCaml";
    longDescription = ''
    Zed is an abstract engine for text edition. It can be used to write text editors, edition widgets, readlines, ...

    Zed uses Camomile to fully support the Unicode specification, and implements an UTF-8 encoded string type with validation, and a rope datastructure to achieve efficient operations on large Unicode buffers. Zed also features a regular expression search on ropes.

    To support efficient text edition capabilities, Zed provides macro recording and cursor management facilities.
    '';
    inherit (src.meta) homepage;
    license = lib.licenses.bsd3;
    maintainers = [
      lib.maintainers.gal_bolle
    ];
  };
}
