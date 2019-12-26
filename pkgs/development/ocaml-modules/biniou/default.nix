{ stdenv, fetchFromGitHub, buildDunePackage, easy-format }:

buildDunePackage rec {
  pname = "biniou";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "ocaml-community";
    repo = pname;
    rev = version;
    sha256 = "0x2kiy809n1j0yf32l7hj102y628jp5jdrkbi3z7ld8jq04h1790";
  };

  propagatedBuildInputs = [ easy-format ];

  postPatch = ''
   patchShebangs .
  '';

  meta = {
    inherit (src.meta) homepage;
    description = "Binary data format designed for speed, safety, ease of use and backward compatibility as protocols evolve";
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    license = stdenv.lib.licenses.bsd3;
  };
}
