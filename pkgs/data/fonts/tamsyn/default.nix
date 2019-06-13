{ stdenv, fetchurl, mkfontdir, mkfontscale }:

let
  version = "1.11";
in stdenv.mkDerivation {
  pname = "tamsyn-font";
  inherit version;

  src = fetchurl {
    url = "http://www.fial.com/~scott/tamsyn-font/download/tamsyn-font-${version}.tar.gz";
    sha256 = "0kpjzdj8sv5871b8827mjgj9dswk75h94jj5iia2bds18ih1pglp";
   };

  nativeBuildInputs = [ mkfontdir mkfontscale ];

  unpackPhase = ''
    tar -xzf $src --strip-components=1
  '';

  installPhase = ''
    # install the pcf fonts (for xorg applications)
    fontDir="$out/share/fonts/tamsyn"
    mkdir -p "$fontDir"
    mv *.pcf "$fontDir"
    mv *.psf.gz "$fontDir"

    cd "$fontDir"
    mkfontdir
    mkfontscale
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "13l7ighfmn3kmqmchlksfg8ss22ndjk71rs0f9fn5p5zk7s4dn5x";

  meta = with stdenv.lib; {
    description = "A monospace bitmap font aimed at programmers";
    longDescription = ''Tamsyn is a monospace bitmap font, primarily aimed at
    programmers. It was derived from Gilles Boccon-Gibod's MonteCarlo. Tamsyn
    font was further inspired by Gohufont, Terminus, Dina, Proggy, Fixedsys, and
    Consolas.
    '';
    homepage = http://www.fial.com/~scott/tamsyn-font/;
    downloadPage = http://www.fial.com/~scott/tamsyn-font/download;
    license = licenses.free;
    maintainers = [ maintainers.rps ];
  };
}

