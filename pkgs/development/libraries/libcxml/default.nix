{ lib
, stdenv
, fetchurl
, fetchpatch
, wafHook
, python3
, pkg-config
, boost
, libxmlxx
, glibmm
, dcpomatic
}:

stdenv.mkDerivation rec {
  pname = "libcxml";
  version = "0.17.2";

  src = fetchurl {
    url = "https://carlh.net/downloads/libcxml/libcxml-${version}.tar.bz2";
    sha256 = "0zbl8msz7wvrnjvki1qj02dljj6g038yz7f707bm2cyazj2sn0d9";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/cth103/libcxml/pull/3/commits/dd0ca672a261d3e1d78e8d5cc5382c2e8df75a4e.patch";
      sha256 = "0ki2nw4q84w8pabfifbqz9z7v5wsd4wvza7x6pppk97giji2960k";
    })
  ];

  postPatch = ''
    substituteInPlace wscript \
      --replace "this_version = " "this_version = 'v${version}' #" \
      --replace "last_version = " "last_version = 'v${version}' #"
  '';

  enableParallelBuilding = true;

  propagatedBuildInputs = [
    libxmlxx
    glibmm
  ];

  buildInputs = [
    boost
    libxmlxx
  ];

  nativeBuildInputs = [
    wafHook
    python3
    pkg-config
  ];

  passthru.tests = {
    # Changes to libcxml should basically always ensure dcpomatic continues to build.
    inherit dcpomatic;
  };

  meta = with lib; {
    description = "A slightly tidier C++ API for parsing XML.";
    homepage = "https://carlh.net/libcxml";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lukegb ];
  };
}
