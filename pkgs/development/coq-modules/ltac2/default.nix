{ stdenv, fetchFromGitHub, which, coq }:

let params = {
  "8.7" = {
    version = "0.1";
    rev = "v0.1-8.7";
    sha256 = "0l6wiwi4cvd0i324fb29i9mdh0ijlxzggw4mrjjy695l2qdnlgg0";
  };
  "8.8" = {
    version = "0.1";
    rev = "0.1";
    sha256 = "1zz26cyv99whj7rrpgnhhm9dfqnpmrx5pqizn8ihf8jkq8d4drz7";
  };
  "8.9" = rec {
    version = "0.2";
    rev = version;
    sha256 = "0xby1kb26r9gcvk5511wqj05fqm9paynwfxlfqkmwkgnfmzk0x73";
  };
  "8.10" = rec {
    version = "0.3";
    rev = version;
    sha256 = "0pzs5nsakh4l8ffwgn4ryxbnxdv2x0r1i7bc598ij621haxdirrr";
  };
};
  param = params.${coq.coq-version};
in

stdenv.mkDerivation rec {
  inherit (param) version;
  name = "coq${coq.coq-version}-ltac2-${version}";

  src = fetchFromGitHub {
    owner = "coq";
    repo = "ltac2";
    inherit (param) rev sha256;
  };

  nativeBuildInputs = [ which ];
  buildInputs = [ coq ] ++ (with coq.ocamlPackages; [ ocaml findlib ])
  ++ stdenv.lib.optional (!stdenv.lib.versionAtLeast coq.coq-version "8.10")
     coq.ocamlPackages.camlp5
  ;

  installFlags = [ "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];

  meta = {
    description = "A robust and expressive tactic language for Coq";
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    license = stdenv.lib.licenses.lgpl21;
    inherit (coq.meta) platforms;
    inherit (src.meta) homepage;
  };

  passthru = {
    compatibleCoqVersions = stdenv.lib.flip builtins.hasAttr params;
  };
}
