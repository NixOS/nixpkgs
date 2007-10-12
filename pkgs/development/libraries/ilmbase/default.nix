args: with args;
stdenv.mkDerivation {
	name = "ilmbase-1.0.0";
	src = fetchurl {
		url = http://FIXME/ilmbase-1.0.0.tar.gz;
		sha256 = "1dpgi3hbff9nflg95r2smb6ssg5bh5g8mj9dxh896w29nh08ipnz";
	};
	configureFlags = "--enable-shared --disable-static";
}
