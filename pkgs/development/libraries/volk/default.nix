{ stdenv
, lib
, fetchFromGitHub
, cmake
, python3
, enableModTool ? true
, removeReferencesTo
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "volk";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "gnuradio";
    repo = pname;
    rev = "v${version}";
    sha256 = "XvX6emv30bSB29EFm6aC+j8NGOxWqHCNv0Hxtdrq/jc=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/macports/macports-ports/e83a55ef196d4283be438c052295b2fc44f3df5b/science/volk/files/patch-cpu_features-add-support-for-ARM64.diff";
      sha256 = "sha256-MNUntVvKZC4zuQsxGQCItaUaaQ1d31re2qjyPFbySmI=";
      extraPrefix = "";
    })
  ];

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
