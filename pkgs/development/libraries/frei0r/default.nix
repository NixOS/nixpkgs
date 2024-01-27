{ lib
, config
, stdenv
, fetchFromGitHub
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
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "dyne";
    repo = "frei0r";
    rev = "v${version}";
    hash = "sha256-5itlZfnloQXV/aCiNgOOZzEeO1d+NLY4qSk8uMVAOmA=";
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
