{ stdenv, fetchurl, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "nordic";
  version = "1.8.1";

  srcs = [
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/V${version}/Nordic.tar.xz";
      sha256 = "0jvc6l093gj9azkrjswdc1kqlyc6drnhsxgpzylzcgjxvxyi9vmd";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/V${version}/Nordic-standard-buttons.tar.xz";
      sha256 = "049hcvccjds465v78sk3cjg7zck36l1zpyrf4p8xinj2h3b74zr8";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/V${version}/Nordic-darker.tar.xz";
      sha256 = "1qaj4x451ic8mx4aak1axw29jm6ymwgh5w3n3mw5kjm1fwg4b5dz";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/V${version}/Nordic-darker-standard-buttons.tar.xz";
      sha256 = "19wczzppimp7sql9v0sq1sc5j0ix51270c58j22mg01kd2h2iivy";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/V${version}/Nordic-bluish-accent.tar.xz";
      sha256 = "1jvjjxiz8q9583f3gidky65s2g5pd5bkvbx0jvwn0p0kz8vlzmzk";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/V${version}/Nordic-bluish-accent-standard-buttons.tar.xz";
      sha256 = "0wqn0aszddq8nbh6c667rwhy7c1zky23a9q3d8gci421n20l6lyd";
    })
  ];

  sourceRoot = ".";

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp -a Nordic* $out/share/themes
    rm $out/share/themes/*/{LICENSE,README.md}
  '';

  meta = with stdenv.lib; {
    description = "Dark Gtk theme created using the awesome Nord color pallete";
    homepage = "https://github.com/EliverLara/Nordic";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
