{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "cimg";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "dtschump";
    repo = "CImg";
    rev = "v.${version}";
    hash = "sha256-laLi3ks5r0C61LDoCEgVqmqZ7/C18qQKxPm4zmQrw78=";
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
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
