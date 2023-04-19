{ lib
, stdenv
, fetchFromGitHub
, gmic
, gmic-qt
}:

stdenv.mkDerivation rec {
  pname = "cimg";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "GreycLab";
    repo = "CImg";
    rev = "v.${version}";
    hash = "sha256-DFTqx4v3Hf2HyT02yBLo4n1yKPuPVz1oa2C5LsIeyCY=";
  };

  outputs = [ "out" "doc" ];

  installPhase = ''
    runHook preInstall

    install -dm 755 $out/include/CImg/plugins $doc/share/doc/cimg/examples
    install -m 644 CImg.h $out/include/
    cp -dr --no-preserve=ownership plugins/* $out/include/CImg/plugins/
    cp -dr --no-preserve=ownership examples/* $doc/share/doc/cimg/examples/
    cp README.txt $doc/share/doc/cimg/

    runHook postInstall
  '';

  passthru.tests = {
    # Need to update in lockstep.
    inherit gmic gmic-qt;
  };

  meta = with lib; {
    homepage = "http://cimg.eu/";
    description = "A small, open source, C++ toolkit for image processing";
    longDescription = ''
      CImg stands for Cool Image. It is easy to use, efficient and is intended
      to be a very pleasant toolbox to design image processing algorithms in
      C++. Due to its generic conception, it can cover a wide range of image
      processing applications.
    '';
    license = licenses.cecill-c;
    maintainers = [ maintainers.AndersonTorres maintainers.lilyinstarlight ];
    platforms = platforms.unix;
  };
}
