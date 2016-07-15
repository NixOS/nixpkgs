{ stdenv, fetchFromGitHub, fetchurl, patchelf, glibc, libX11, libXt, perl }:

stdenv.mkDerivation rec {
  name = "rebol-nightly-${version}";
  version = "3-alpha";
  src = fetchFromGitHub {
    rev = "bd45d0de512ff5953e098301c3d610f6024515d6";
    owner = "earl";
    repo = "r3";
    sha256 = "0pirn6936rxi894xxdvj7xdwlwmmxq2wz36jyjnj26667v2n543c";
  };

  r3 = fetchurl {
    url = "http://rebolsource.net/downloads/experimental/r3-linux-x64-gbf237fc";
    sha256 = "0cm86kn4lcbvyy6pqg67x53y0wz353y0vg7pfqv65agxj1ynxnrx";
    name = "r3";
  };

  buildInputs = [ glibc libX11 libXt perl ];

  configurePhase = ''
    cp ${r3} make/r3-make
    chmod 777 make/r3-make
    patchelf  --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" ./make/r3-make
    cd make
    perl -pi -e 's#-m32##g' makefile
    perl -pi -e 's#sudo .*#echo#g' makefile
    make prep
  '';
  buildPhase = ''
    make
    mkdir -p $out/bin
    cp r3 $out/bin
  '';

  meta = with stdenv.lib; {
    description = ''Relative expression based object language, a language where code is data'';
    maintainers = with maintainers; [ vrthra ];
    platforms = [ "x86_64-linux" ];
    license = licenses.asl20;
    homepage = http://www.rebol.com/;
  };
}
