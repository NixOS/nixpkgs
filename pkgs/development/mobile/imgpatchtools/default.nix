{ stdenv, fetchzip, bzip2, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "imgpatchtools-${version}";
  version = "0.3";

  src = fetchzip {
    url = "https://github.com/erfanoabdi/imgpatchtools/archive/${version}.tar.gz";
    sha256 = "1cwp1hfhip252dz0mbkhrsrkws6m15k359n4amw2vfnglnls8czd";
  };

  buildInputs = [ bzip2 openssl zlib ];

  installPhase = "install -Dt $out/bin bin/*";

  meta = with stdenv.lib; {
    description = "Tools to manipulate Android OTA archives";
    longDescription = ''
      This package is useful for Android development. In particular, it can be
      used to extract ext4 /system image from Android distribution ZIP archives
      such as those distributed by LineageOS and Replicant, via BlockImageUpdate
      utility. It also includes other, related, but arguably more advanced tools
      for OTA manipulation.
    '';
    homepage = https://github.com/erfanoabdi/imgpatchtools;
    license = licenses.gpl3;
    maintainers = with maintainers; [ yegortimoshenko ];
    platforms = platforms.linux;
  };
}
