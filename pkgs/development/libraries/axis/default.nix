{stdenv, fetchurl}:

stdenv.mkDerivation {
	name = "axis-1.3";
	directory = "axis-1_3";
	builder = ./builder.sh;
	src = fetchurl {
		url = "http://apache.cs.uu.nl/dist/ws/axis/1_3/axis-bin-1_3.tar.gz";
		md5 = "dd8203f08c37872f4fd2bfb45c4bfe04";
	};
	inherit stdenv;
}
