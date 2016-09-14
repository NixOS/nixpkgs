{ lib, clangStdenv, fetchFromGitHub, llvm }:

clangStdenv.mkDerivation {
  name = "halide-2015.10.22";

  src = fetchFromGitHub {
    owner = "halide";
    repo = "Halide";
    rev = "release_2015_10_22";
    sha256 = "1fmgz43va468194nxpg4yhmck8819h0ckk7dzydh8m8vj0hyqkva";
  };

  buildInputs = [ llvm ];

  # It's not sufficent to pass CXX=clang++ in buildInputs
  # because one line of the makefile has g++ hardcoded
  patchPhase = ''
    substituteInPlace Makefile --replace "g++" "c++"
  '';

  installPhase = ''
    mkdir -p $out/include $out/lib $out/share/halide/tutorial/images $out/share/halide/tools $out/share/halide/tutorial/figures
    cp bin/libHalide.a bin/libHalide.so $out/lib
    cp include/Halide.h $out/include
    cp include/HalideRuntim*.h $out/include
    cp tutorial/images/*.png $out/share/halide/tutorial/images
    cp tutorial/figures/*.gif $out/share/halide/tutorial/figures
    cp tutorial/figures/*.jpg $out/share/halide/tutorial/figures
    cp tutorial/figures/*.mp4 $out/share/halide/tutorial/figures
    cp tutorial/*.cpp $out/share/halide/tutorial
    cp tutorial/*.h $out/share/halide/tutorial
    cp tutorial/*.sh $out/share/halide/tutorial
    cp tools/mex_halide.m $out/share/halide/tools
    cp tools/GenGen.cpp $out/share/halide/tools
    cp tools/halide_image.h $out/share/halide/tools
    cp tools/halide_image_io.h $out/share/halide/tools
  '' + lib.optionalString clangStdenv.isDarwin ''
    install_name_tool -id $out/lib/libHalide.so $out/lib/libHalide.so
  '';

  meta = {
    description = "A language for image processing and computational photography";
    homepage = http://halide-lang.org;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.spwhitt ];
    platforms = lib.platforms.unix;
  };
}
