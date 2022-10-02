{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, boost, gtest, zlib }:

stdenv.mkDerivation rec {
  pname = "lucene++";
  version = "3.0.8";

  src = fetchFromGitHub {
    owner = "luceneplusplus";
    repo = "LucenePlusPlus";
    rev = "rel_${version}";
    sha256 = "12v7r62f7pqh5h210pb74sfx6h70lj4pgfpva8ya2d55fn0qxrr2";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost gtest zlib ];

  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" ];

  patches = [
    (fetchpatch {
      name = "pkgconfig_use_correct_LIBDIR_for_destination_library";
      url = "https://github.com/luceneplusplus/LucenePlusPlus/commit/39cd44bd54e918d25ee464477992ad0dc234dcba.patch";
      sha256 = "sha256-PP6ENNhPJMWrYDlTnr156XV8d5aX/VNX8v4vvi9ZiWo";
    })
  ];

  postPatch = ''
    substituteInPlace src/test/CMakeLists.txt \
      --replace "add_subdirectory(gtest)" ""
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    LD_LIBRARY_PATH=$PWD/src/contrib:$PWD/src/core \
            src/test/lucene++-tester
    runHook postCheck
  '';

  postInstall = ''
    mv $out/include/pkgconfig $out/lib/
    cp $src/src/contrib/include/*h $out/include/lucene++/
  '';

  meta = {
    description = "C++ port of the popular Java Lucene search engine";
    homepage = "https://github.com/luceneplusplus/LucenePlusPlus";
    license = with lib.licenses; [ asl20 lgpl3Plus ];
    platforms = lib.platforms.linux;
  };
}
