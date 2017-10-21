{stdenv, buildOcaml, fetchurl, batteries, pcre}:

buildOcaml rec {
  name = "jingoo";
  version = "1.2.7";

  src = fetchurl {
    url = "https://github.com/tategakibunko/jingoo/archive/v${version}.tar.gz";
    sha256 = "8ffc5723d77b323a12761981d048c046af77db47543a4b1076573aa5f4003009";
  };

  propagatedBuildInputs = [ batteries pcre ];

  preInstall = "mkdir -p $out/bin";
  installFlags = "BINDIR=$(out)/bin";

  meta = with stdenv.lib; {
    homepage = https://github.com/tategakibunko/jingoo;
    description = "OCaml template engine almost compatible with jinja2";
    license = licenses.mit;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
