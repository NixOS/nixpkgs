{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
	name = "hawknl-1.34";
	src = fetchurl {
		url = http://hawksoft.com/download/files/HawkNL168src.zip;
		sha256 = "11shn2fbxj3w0j77w0234pqyj1368x686kkgv09q5yqhi1cdp028";
	};

  buildInputs = [ unzip ];

  makefile = "makefile.linux";

  patchPhase = ''
    sed -i s/soname,NL/soname,libNL/ src/makefile.linux
  '';

  preInstall = ''
    sed -i s,/usr/local,$out, src/makefile.linux
    mkdir -p $out/lib $out/include
  '';

  meta = {
    homepage = http://hawksoft.com/hawknl/;
    description = "Free, open source, game oriented network API";
    license = "LGPLv2+";
  };
}
