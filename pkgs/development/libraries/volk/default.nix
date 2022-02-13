{ stdenv
, lib
, fetchFromGitHub
, cmake
, python3
, enableModTool ? true
, removeReferencesTo
}:

stdenv.mkDerivation rec {
  pname = "volk";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "gnuradio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kbZE0zGFAunWDo35Ar9eGKnOtitAoOcr0p5EpPsxM3Y=";
    fetchSubmodules = true;
  };

  cmakeFlags = lib.optionals (!enableModTool) [ "-DENABLE_MODTOOL=OFF" ];
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
