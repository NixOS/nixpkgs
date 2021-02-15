{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, cppunit
, python3
, enableModTool ? true
, removeReferencesTo
}:

stdenv.mkDerivation rec {
  pname = "volk";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "gnuradio";
    repo = pname;
    rev = "v${version}";
    sha256 = "fuHJ+p5VN4ThdbQFbzB08VCuy/Zo7m/I1Gs5EQGPeNY=";
    fetchSubmodules = true;
  };

  patches = [
    # Fixes a failing test: https://github.com/gnuradio/volk/pull/434
    (fetchpatch {
      url = "https://github.com/gnuradio/volk/pull/434/commits/bce8531b6f1a3c5abe946ed6674b283d54258281.patch";
      sha256 = "OLW9uF6iL47z63kjvYqwsWtkINav8Xhs+Htqg6Kr4uI=";
    })
  ];
  cmakeFlags = lib.optionals (!enableModTool) [ "-DENABLE_MODTOOL=OFF" ];
  postInstall = ''
    ${removeReferencesTo}/bin/remove-references-to -t ${stdenv.cc} $(readlink -f $out/lib/libvolk.so)
  '';

  nativeBuildInputs = [
    cmake
    python3
    python3.pkgs.Mako
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "http://libvolk.org/";
    description = "The Vector Optimized Library of Kernels";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.all;
  };
}
