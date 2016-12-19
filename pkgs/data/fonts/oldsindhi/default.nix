{ stdenv, fetchurl, p7zip }:

stdenv.mkDerivation rec {
  name = "oldsindhi-${version}";
  version = "0.1";

  src = fetchurl {
    url = "https://github.com/MihailJP/oldsindhi/releases/download/0.1/OldSindhi-0.1.7z";
    sha256 = "1sbmxyxi81k88hkfw7gnnpgd5vy2vyj5y5428cd6nz4zlaclgq8z";
  };

  buildInputs = [ p7zip ];

  unpackCmd = "7z x $curSrc";

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/doc/${name}
    cp -v *.ttf $out/share/fonts/truetype/
    cp -v README *.txt $out/share/doc/${name}
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/MihailJP/oldsindhi;
    description = "Free Sindhi Khudabadi font";
    maintainers = with maintainers; [ mathnerd314 ];
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
