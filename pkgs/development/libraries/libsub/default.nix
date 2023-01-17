{ lib
, stdenv
, fetchurl
, wafHook
, python3
, pkg-config
, openssl
, boost
, libdcp
, libcxml
, libtool
, dcpomatic
}:

stdenv.mkDerivation rec {
  pname = "libsub";
  version = "1.6.5";

  src = fetchurl {
    url = "https://carlh.net/downloads/libsub/libsub-${version}.tar.bz2";
    sha256 = "1r66cn9p83dlwhpppf17nkps246yfjalqv1lsdmydn2yhifcpxcx";
  };

  postPatch = ''
    substituteInPlace wscript \
      --replace "this_version = " "this_version = 'v${version}' #" \
      --replace "last_version = " "last_version = 'v${version}' #"
  '';

  enableParallelBuilding = true;

  buildInputs = [
    openssl
    boost
    libdcp
    libcxml
    libtool
  ];

  nativeBuildInputs = [
    wafHook
    python3
    pkg-config
  ];

  passthru.tests = {
    # Changes to libsub should basically always ensure dcpomatic continues to build.
    inherit dcpomatic;
  };

  meta = with lib; {
    description = "Library to read and write subtitles in STL/SubRip/DCP/SSA format";
    homepage = "https://carlh.net/libsub";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lukegb ];
  };
}
