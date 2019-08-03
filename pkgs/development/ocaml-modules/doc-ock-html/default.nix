{ stdenv, fetchFromGitHub, buildDunePackage, doc-ock, tyxml, xmlm }:

buildDunePackage rec {
  pname = "doc-ock-html";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "ocaml-doc";
    repo = pname;
    rev = "v${version}";
    sha256 = "1y620h48qrplmcm78g7c78zibpkai4j3icwmnx95zb3r8xq8554y";
  };

  propagatedBuildInputs = [ doc-ock tyxml xmlm ];

  meta = {
    description = "From doc-ock to HTML";
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
