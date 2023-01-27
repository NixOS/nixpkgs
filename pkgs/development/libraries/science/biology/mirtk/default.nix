{ lib, stdenv, gtest, fetchFromGitHub, cmake, boost, eigen, python3, vtk_8, zlib, tbb }:

stdenv.mkDerivation rec {
  version = "2.0.0";
  pname = "mirtk";

  src = fetchFromGitHub {
    owner = "BioMedIA";
    repo = "MIRTK";
    rev = "v${version}";
    sha256 = "0i2v97m66ir5myvi5b123r7zcagwy551b73s984gk7lksl5yiqxk";
    fetchSubmodules = true;
  };

  cmakeFlags = [
    "-DWITH_VTK=ON"
    "-DBUILD_ALL_MODULES=ON"
    "-DWITH_TBB=ON"
  ];

  doCheck = true;

  checkPhase = ''
    ctest -E '(Polynomial|ConvolutionFunction|Downsampling|EdgeTable|InterpolateExtrapolateImage)'
  '';
  # testPolynomial - segfaults for some reason
  # testConvolutionFunction, testDownsampling - main not called correctly
  # testEdgeTable, testInterpolateExtrapolateImageFunction - setup fails

  postInstall = ''
    install -Dm644 -t "$out/share/bash-completion/completions/mirtk" share/completion/bash/mirtk
  '';

  nativeBuildInputs = [ cmake gtest ];
  buildInputs = [ boost eigen python3 vtk_8 zlib tbb ];

  meta = with lib; {
    homepage = "https://github.com/BioMedIA/MIRTK";
    description = "Medical image registration library and tools";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.linux;
    license = licenses.asl20;
  };
}
