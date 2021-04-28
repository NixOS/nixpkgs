{ buildOctavePackage
, lib
, fetchurl
, struct
, gnutls
, pkg-config
}:

buildOctavePackage rec {
  pname = "parallel";
  version = "4.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0wmpak01rsccrnb8is7fsjdlxw15157sqyf9s2fabr16yykfmvi8";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gnutls
  ];

  requiredOctavePackages = [
    struct
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/parallel/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Parallel execution package";
  };
}
