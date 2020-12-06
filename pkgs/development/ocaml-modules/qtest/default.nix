{ lib, buildDunePackage, fetchFromGitHub, qcheck }:

buildDunePackage rec {
  pname = "qtest";
  version = "2.11.1";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "vincent-hugot";
    repo = pname;
    rev = "v${version}";
    sha256 = "01aaqnblpkrkv1b2iy5cwn92vxdj4yjiav9s2nvvrqz5m8b9hi1f";
  };

  propagatedBuildInputs = [ qcheck ];

  meta = {
    description = "Inline (Unit) Tests for OCaml";
    inherit (src.meta) homepage;
    maintainers = with lib.maintainers; [ vbgl ];
    license = lib.licenses.gpl3;
  };
}
