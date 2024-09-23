{
  lib,
  stdenv,
  fetchurl,
  cmake,
  enableWX ? false,
  wxGTK32,
  Cocoa,
  enableXWin ? false,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "plplot";
  version = "5.15.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/${pname}/${version}%20Source/${pname}-${version}.tar.gz";
    sha256 = "0ywccb6bs1389zjfmc9zwdvdsvlpm7vg957whh6b5a96yvcf8bdr";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs =
    lib.optional enableWX wxGTK32
    ++ lib.optional (enableWX && stdenv.isDarwin) Cocoa
    ++ lib.optional enableXWin xorg.libX11;

  passthru = {
    inherit (xorg) libX11;
    inherit
      enableWX
      enableXWin
      ;
  };

  cmakeFlags = [
    "-DBUILD_TEST=ON"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Cross-platform scientific graphics plotting library";
    mainProgram = "pltek";
    homepage = "https://plplot.org";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.lgpl2;
  };
}
