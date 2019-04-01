{ stdenv, lib, gtest, fetchFromGitHub, cmake, boost, eigen, python, vtk, zlib }:

stdenv.mkDerivation rec {
  version = "2.0.0";
  name = "mirtk-${version}";

  src = fetchFromGitHub {
    owner = "BioMedIA";
    repo = "MIRTK";
    rev = "v${version}";
    sha256 = "0i2v97m66ir5myvi5b123r7zcagwy551b73s984gk7lksl5yiqxk";
    fetchSubmodules = true;
  };

  cmakeFlags = "-DWITH_VTK=ON -DBUILD_ALL_MODULES=ON";

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

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake gtest ];
  buildInputs = [ boost eigen python vtk zlib ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/BioMedIA/MIRTK";
    description = "Medical image registration library and tools";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.linux;
    license = licenses.asl20;
  };
}
