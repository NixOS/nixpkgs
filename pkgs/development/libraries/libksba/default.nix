{ stdenv, fetchurl, libgpgerror }:

stdenv.mkDerivation rec {
  name = "libksba-1.3.5";

  src = fetchurl {
    url = "mirror://gnupg/libksba/${name}.tar.bz2";
    sha256 = "0h53q4sns1jz1pkmhcz5wp9qrfn9f5g9i3vjv6dafwzzlvblyi21";
  };

  outputs = [ "out" "dev" "info" ];

  propagatedBuildInputs = [ libgpgerror ];

  postInstall = ''
    mkdir -p $dev/bin
    mv $out/bin/*-config $dev/bin/
    rmdir --ignore-fail-on-non-empty $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = https://www.gnupg.org;
    description = "CMS and X.509 access library";
    platforms = platforms.all;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ wkennington ];
  };
}
