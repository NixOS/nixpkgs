{ buildOctavePackage
, lib
, fetchurl
, zeromq
, pkg-config
, autoreconfHook
}:

buildOctavePackage rec {
  pname = "zeromq";
  version = "1.5.3";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "1h0pb2pqbnyiavf7r05j8bqxqd8syz16ab48hc74nlnx727anfwl";
  };

  preAutoreconf = ''
    cd src
  '';

  postAutoreconf = ''
    cd ..
  '';

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  propagatedBuildInputs = [
    zeromq
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/zeromq/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "ZeroMQ bindings for GNU Octave";
  };
}
