args: with args;
stdenv.mkDerivation {
	name = "decibel-0.5.0";

	src = fetchurl {
		url = http://decibel.kde.org/fileadmin/downloads/decibel/releases/decibel-0.5.0.tar.gz;
		sha256 = "07visasid4mpzm0ba5j9qy0lxxb6451lvbr2gnc1vzfvjagffqz4";
	};

	buildInputs = [kdelibs kdebase ];
}
