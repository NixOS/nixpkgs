{ lib
, config
, stdenv
, fetchurl
, cairo
, cmake
, opencv
, pcre
, pkg-config
, cudaSupport ? config.cudaSupport
, cudaPackages
}:

stdenv.mkDerivation rec {
  pname = "frei0r-plugins";
  version = "1.8.0";

  src = fetchurl {
    url = "https://files.dyne.org/frei0r/releases/${pname}-${version}.tar.gz";
    hash = "sha256-RaKGVcrwVyJ7RCuADKOJnpNJBRXIHiEtIZ/fSnYT9cQ=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    cairo
    opencv
    pcre
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvcc
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    for f in $out/lib/frei0r-1/*.so* ; do
      ln -s $f "''${f%.*}.dylib"
    done
  '';

  meta = with lib; {
    homepage = "https://frei0r.dyne.org";
    description = "Minimalist, cross-platform, shared video plugins";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
