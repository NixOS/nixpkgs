{ lib
, stdenv
, fetchurl
, cmake
, enableWX ? false
, wxGTK31, wxmac
, enableXWin ? false
, libX11
}:

let
  wxWidgets = (if stdenv.isDarwin then wxmac else wxGTK31);
in stdenv.mkDerivation rec {
  pname   = "plplot";
  version = "5.15.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/${pname}/${version}%20Source/${pname}-${version}.tar.gz";
    sha256 = "0ywccb6bs1389zjfmc9zwdvdsvlpm7vg957whh6b5a96yvcf8bdr";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optional enableWX wxWidgets
    ++ lib.optional enableXWin libX11;

  passthru = {
    inherit
      enableWX
      wxWidgets
      enableXWin
      libX11
    ;
  };

  cmakeFlags = [
    "-DBUILD_TEST=ON"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Cross-platform scientific graphics plotting library";
    homepage    = "https://plplot.org";
    maintainers = with maintainers; [ bcdarwin ];
    platforms   = platforms.unix;
    license     = licenses.lgpl2;
  };
}
