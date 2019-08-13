{ stdenv, fetchFromGitHub, unzip }:

stdenv.mkDerivation {
  pname = "openfx";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "ofxa";
    repo = "openfx";
    rev = "OFX_Release_1_4_TAG";
    sha256 = "0k9ggzr6bisn77mipjfvawg3mv4bz50b63v8f7w1jhldi1sfy548";
  };

  buildInputs = [ unzip ];

  outputs = [ "dev" "out" ];

  enableParallelBuilding = true;

  buildPhase = ''
      mkdir $dev
      mkdir $out
      '';

  installPhase = ''
     mkdir -p $dev/include/OpenFX/
     cp -r include/* $dev/include/OpenFX/
  '';

  meta = with stdenv.lib; {
    description = "Image processing plug-in standard";
    homepage = "http://openeffects.org/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ maintainers.guibou ];
  };
}
