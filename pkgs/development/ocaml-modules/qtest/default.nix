{ lib, buildDunePackage, fetchFromGitHub, qcheck }:

buildDunePackage rec {
  pname = "qtest";
  version = "2.11.2";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "vincent-hugot";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VLY8+Nu6md0szW4RVxTFwlSQ9kyrgUqf7wQEA6GW8BE=";
  };

  propagatedBuildInputs = [ qcheck ];

  meta = {
    description = "Inline (Unit) Tests for OCaml";
    inherit (src.meta) homepage;
    maintainers = with lib.maintainers; [ vbgl ];
    license = lib.licenses.gpl3;
  };
}
