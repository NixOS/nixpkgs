{ stdenv, fetchFromGitHub, fonttosfnt, mkfontdir }:

stdenv.mkDerivation rec {
  pname = "cherry";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "turquoise-hexagon";
    repo = pname;
    rev = version;
    sha256 = "13zkxwp6r6kcxv4x459vwscr0n0sik4a3kcz5xnmlpvcdnbxi586";
  };

  nativeBuildInputs = [ fonttosfnt mkfontdir ];

  buildPhase = ''
    patchShebangs make.sh
    ./make.sh
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/misc
    cp *.otb $out/share/fonts/misc

    # create fonts.dir so NixOS xorg module adds to fp
    mkfontdir $out/share/fonts/misc
  '';

  meta = with stdenv.lib; {
    description = "cherry font";
    homepage = https://github.com/turquoise-hexagon/cherry;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

