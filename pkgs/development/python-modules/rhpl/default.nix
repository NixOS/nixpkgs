{stdenv, fetchurl, rpmextract, python, wirelesstools, gettext}:

stdenv.mkDerivation {
  name = "rhpl-0.218";
  
  src = fetchurl {
    url = http://ftp-stud.hs-esslingen.de/pub/Mirrors/archive.fedoraproject.org/fedora/linux/releases/10/Everything/source/SRPMS//rhpl-0.218-1.src.rpm;
    md5 = "a72c6b66df782ca1d4950959d2aad292";
  };
  
  inherit python;
  
  builder = ./builder.sh;
  
  buildInputs = [ rpmextract python wirelesstools gettext ];
}
