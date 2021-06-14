{ buildPackages, lib, stdenv, fetchurl, gettext, libgpgerror }:

stdenv.mkDerivation rec {
  name = "libksba-1.5.0";

  src = fetchurl {
    url = "mirror://gnupg/libksba/${name}.tar.bz2";
    sha256 = "1fm0mf3wq9fmyi1rmc1vk2fafn6liiw2mgxml3g7ybbb44lz2jmf";
  };

  outputs = [ "out" "dev" "info" ];

  buildInputs = [ gettext ];
  propagatedBuildInputs = [ libgpgerror ];
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  configureFlags = [ "--with-libgpg-error-prefix=${libgpgerror.dev}" ];

  postInstall = ''
    mkdir -p $dev/bin
    mv $out/bin/*-config $dev/bin/
    rmdir --ignore-fail-on-non-empty $out/bin
  '';

  meta = with lib; {
    homepage = "https://www.gnupg.org";
    description = "CMS and X.509 access library";
    platforms = platforms.all;
    license = licenses.lgpl3;
  };
}
