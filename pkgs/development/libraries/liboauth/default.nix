{ fetchurl, lib, stdenv, nss, nspr, pkg-config }:


stdenv.mkDerivation rec {
  name = "liboauth-1.0.3";

  src = fetchurl {
    url = "mirror://sourceforge/liboauth/${name}.tar.gz";
    sha256 = "07w1aq8y8wld43wmbk2q8134p3bfkp2vma78mmsfgw2jn1bh3xhd";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [ nss nspr ];

  configureFlags = [ "--enable-nss" ];

  postInstall = ''
    substituteInPlace $out/lib/liboauth.la \
      --replace "-lnss3" "-L${nss.out}/lib -lnss3"
  '';

  meta = with lib; {
    platforms = platforms.linux;
    description = "C library implementing the OAuth secure authentication protocol";
    homepage = "http://liboauth.sourceforge.net/";
    repositories.git = "https://github.com/x42/liboauth.git";
    license = licenses.mit;
  };

}
