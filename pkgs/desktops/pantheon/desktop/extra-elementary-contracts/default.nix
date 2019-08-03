{ stdenv, substituteAll, fetchFromGitHub, file-roller, gnome-bluetooth }:

stdenv.mkDerivation rec {
  pname = "extra-elementary-contracts";
  version = "2018-08-21";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "worldofpeace";
    repo = pname;
    rev = "a05dfb00695854163805b666185e3e9f31b6eb83";
    sha256 = "0fkaf2w4xg0n9faj74rgzy7gvd3yz112l058b157a3pr39vpci7g";
  };

  patches = [
    (substituteAll {
      src = ./exec-path.patch;
      file_roller = "${file-roller}";
      gnome_bluetooth = "${gnome-bluetooth}";
    })
  ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/contractor

    cp *.contract $out/share/contractor/
  '';

  meta = with stdenv.lib; {
    description = "Extra contractor files for elementary";
    homepage = https://github.com/worldofpeace/extra-elementary-contracts;
    license = licenses.gpl2;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
