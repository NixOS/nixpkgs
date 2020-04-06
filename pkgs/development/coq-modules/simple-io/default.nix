{ stdenv, fetchFromGitHub, coq, coq-ext-lib }:

stdenv.mkDerivation rec {
  version = "1.2.0";
  name = "coq${coq.coq-version}-simple-io-${version}";
  src = fetchFromGitHub {
    owner = "Lysxia";
    repo = "coq-simple-io";
    rev = version;
    sha256 = "1im1vwp7l7ha8swnhgbih0qjg187n8yx14i003nf6yy7p0ryxc9m";
  };

  buildInputs = [ coq ] ++ (with coq.ocamlPackages; [ ocaml ocamlbuild ]);

  propagatedBuildInputs = [ coq-ext-lib ];

  doCheck = true;
  checkTarget = "test";

  installFlags = [ "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];

  meta = {
    description = "Purely functional IO for Coq";
    inherit (src.meta) homepage;
    inherit (coq.meta) platforms;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.7" "8.8" "8.9" "8.10" ];
  };

}
