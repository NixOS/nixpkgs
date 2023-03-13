{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, python3
, enableModTool ? true
, removeReferencesTo
}:

stdenv.mkDerivation rec {
  pname = "volk";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "gnuradio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kI4IuO6TLplo5lLAGIPWQWtePcjIEWB9XaJDA6WlqSg=";
    fetchSubmodules = true;
  };
  patches = [
    # Remove a failing test
    (fetchpatch {
      url = "https://github.com/gnuradio/volk/commit/fe2e4a73480bf2ac2e566052ea682817dddaf61f.patch";
      hash = "sha256-Vko/Plk7u6UAr32lieU+T9G34Dkg9EW3Noi/NArpRL4=";
    })
  ];

  cmakeFlags = lib.optionals (!enableModTool) [
    "-DENABLE_MODTOOL=OFF"
  ];

  postInstall = lib.optionalString (!stdenv.isDarwin) ''
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
