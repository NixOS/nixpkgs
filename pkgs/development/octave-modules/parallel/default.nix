{
  buildOctavePackage,
  lib,
  fetchurl,
  struct,
  gnutls,
  pkg-config,
}:

buildOctavePackage rec {
  pname = "parallel";
  version = "4.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "1h8vw2r42393px6dk10y3lhpxl168r9d197f9whz6lbk2rg571pa";
  };
  patches = [
    ../database/c_verror.patch
  ];

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
    # Although upstream has added an identical patch to that of ../database, it
    # still won't build with octave>8.1
    broken = true;
  };
}
