{ stdenv, fetchFromGitHub, coq, bignums }:

let params =
  let v_8_8 = {
      version = "8.8";
      sha256 = "075yjczk79pf1hd3lgdjiz84ilkzfxjh18lgzrhhqp7d3kz5lxp5";
    };
  in
  {
    "8.7" = {
      version = "8.7.2";
      sha256 = "15zlcrx06qqxjy3nhh22wzy0rb4npc8l4nx2bbsfsvrisbq1qb7k";
    };
    "8.8" = v_8_8;
    "8.9" = v_8_8;
    };
  param = params."${coq.coq-version}"
; in

stdenv.mkDerivation rec {

  inherit (param) version;
  name = "coq${coq.coq-version}-coqprime-${version}";

  src = fetchFromGitHub {
    owner = "thery";
    repo = "coqprime";
    rev = "v${version}";
    inherit (param) sha256;
  };

  buildInputs = [ coq ];

  propagatedBuildInputs = [ bignums ];

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = with stdenv.lib; {
    description = "Library to certify primality using Pocklington certificate and Elliptic Curve Certificate";
    license = licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (coq.meta) platforms;
    inherit (src.meta) homepage;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.hasAttr v params;
  };
}
