args: with args;
let

srcA=
	fetchurl {
		url = http://www.cl.cam.ac.uk/~mgk25/download/ucs-fonts.tar.gz;
		sha256 = "11vripxw9dgasbgcgs1z4hc1yjdypby2grj6y3c1a0c9w3v40kix";
	};
srcB=
	fetchurl {
		url = http://www.cl.cam.ac.uk/~mgk25/download/ucs-fonts-asian.tar.gz;
		sha256 = "0fgka3vy8agbkp6xjq7igilbv88p8m9hh2qyikqhcm2qajdvzc4j";
	};
srcC=
	fetchurl {
		url = http://www.cl.cam.ac.uk/~mgk25/download/ucs-fonts-75dpi100dpi.tar.gz;
		sha256 = "08vqr8yb636xa1s28vf3pm22dzkia0gisvsi2svqjqh4kk290pzh";
	};	

in
wrapFonts (stdenv.mkDerivation {

	name = "ucs-fonts";
	phases = ["installPhase"];
	installPhase = ''
		tar xf ${srcA}
		tar xf ${srcB}
		tar xf ${srcC}
		mkdir -p $out/share/fonts/ucs-fonts
		cp *.bdf $out/share/fonts/ucs-fonts
	'';

	meta = {
		description = "
			UCS-fonts - Unicode bitmap fonts.
		";
		src = [srcA srcB srcC];
	};
})

