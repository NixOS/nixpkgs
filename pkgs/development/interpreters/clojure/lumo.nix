{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "lumo-${version}";
  version = "1.8.0-beta";

  src = fetchurl {
    url = "https://github.com/anmonteiro/lumo/releases/download/${version}/lumo_linux64.zip";
    sha256 = "0p06994w48pbgy8xwc1sz3gg609ardsdhmjafdf7qk4gclyiqs5i";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
     unzip -j $src
  '';

  installPhase = ''
    patchelf --interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath ${stdenv.cc.cc.lib}/lib64 lumo
    mkdir -p $out/bin
    cp lumo $out/bin/lumo
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/anmonteiro/lumo/;
    description = "Fast, cross-platform, standalone ClojureScript environment";
    maintainers = [ maintainers.jgertm ];
    license = licenses.epl10;
    platforms = platforms.all;
  };
}
