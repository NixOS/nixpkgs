{ stdenv, fetchFromGitHub, coq, ocamlPackages }:

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-dpdgraph-0.5";
  src = fetchFromGitHub {
    owner = "Karmaki";
    repo = "coq-dpdgraph";
    rev = "227a6a28bf11cf1ea56f359160558965154dd176";
    sha256 = "1vxf7qq37mnmlclkr394147xvrky3p98ar08c4wndwrp41gfbxhq";
  };

  buildInputs = [ coq ]
  ++ (with ocamlPackages; [ ocaml findlib ocamlgraph ]);

  preInstall = ''
    mkdir -p $out/bin
  '';

  installFlags = ''
    COQLIB=$(out)/lib/coq/${coq.coq-version}/
    BINDIR=$(out)/bin
  '';

  meta = {
    description = "Build dependency graphs between Coq objects";
    license = stdenv.lib.licenses.lgpl21;
    homepage = https://github.com/Karmaki/coq-dpdgraph/;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
    platforms = coq.meta.platforms;
  };
}
