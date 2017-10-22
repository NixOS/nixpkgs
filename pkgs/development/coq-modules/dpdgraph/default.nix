{ stdenv, fetchFromGitHub, autoreconfHook, coq, ocamlPackages }:

let param = {
  "8.6" = {
    version = "0.6.1";
    rev = "c3b87af6bfa338e18b83f014ebd0e56e1f611663";
    sha256 = "1jaafkwsb5450378nprjsds1illgdaq60gryi8kspw0i25ykz2c9";
  };
  "8.5" = {
    version = "0.6";
    rev = "v0.6";
    sha256 = "0qvar8gfbrcs9fmvkph5asqz4l5fi63caykx3bsn8zf0xllkwv0n";
  };
}."${coq.coq-version}"; in

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-dpdgraph-${param.version}";
  src = fetchFromGitHub {
    owner = "Karmaki";
    repo = "coq-dpdgraph";
    inherit (param) rev sha256;
  };

  nativeBuildInputs = [ autoreconfHook ];
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
