{ buildPackages, stdenv, fetchurl, gettext, libgpgerror }:

stdenv.mkDerivation rec {
  name = "libksba-1.4.0";

  src = fetchurl {
    url = "mirror://gnupg/libksba/${name}.tar.bz2";
    sha256 = "1dj1razn35srkgadx3i30yr0q037cr0dn54m6a54vxgh3zlsirmz";
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

  meta = with stdenv.lib; {
    homepage = "https://www.gnupg.org";
    description = "CMS and X.509 access library";
    platforms = platforms.all;
    license = licenses.lgpl3;
  };
}
