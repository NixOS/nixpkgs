{ lib, stdenv, fetchFromGitHub, cmake, boost, eigen, libxml2, mpi, python3
, mklSupport ? true, mkl
}:

stdenv.mkDerivation rec {
  pname = "FEBio";
  version = "3.6";

  src = fetchFromGitHub {
    owner = "febiosoftware";
    repo = pname;
    rev = "v${version}";
    sha256 = "187s4lyzr806xla3smq3lsvj3f6wxlhfkban89w0fnyfmfb8w9am";
  };

  patches = [
    ./fix-cmake.patch  # cannot find mkl libraries without this
  ];

  cmakeFlags = lib.optional mklSupport "-DUSE_MKL=On"
    ++ lib.optional mklSupport "-DMKLROOT=${mkl}"
  ;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include
    cp -R lib bin $out/
    cp -R ../FECore \
      ../FEBioFluid \
      ../FEBioLib \
      ../FEBioMech \
      ../FEBioMix \
      ../FEBioOpt \
      ../FEBioPlot \
      ../FEBioXML \
      ../NumCore \
      $out/include

    runHook postInstall
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost eigen libxml2 mpi python3 python3.pkgs.numpy ]
   ++ lib.optional mklSupport mkl
  ;

  meta = {
    description = "FEBio Suite Solver";
    license = with lib.licenses; [ mit ];
    homepage = "https://febio.org/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Scriptkiddi ];
  };
}
