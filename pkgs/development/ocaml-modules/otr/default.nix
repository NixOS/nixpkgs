{ lib, fetchFromGitHub, buildDunePackage
, cstruct, sexplib0, rresult, nocrypto, astring
}:

buildDunePackage rec {
  pname = "otr";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "ocaml-otr";
    rev    = "${version}";
    sha256 = "0iz6p85a0jxng9aq9blqsky173zaqfr6wlc5j48ad55lgwzlbih5";
  };

  propagatedBuildInputs = [ cstruct sexplib0 rresult nocrypto astring ];

  doCheck = true;
  meta = with lib; {
    homepage = https://github.com/hannesm/ocaml-otr;
    description = "Off-the-record messaging protocol, purely in OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
