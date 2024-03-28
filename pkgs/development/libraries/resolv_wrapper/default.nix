{ lib, stdenv, fetchurl, cmake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "resolv_wrapper";
  version = "1.1.8";

  src = fetchurl {
    url = "mirror://samba/cwrap/resolv_wrapper-${version}.tar.gz";
    sha256 = "sha256-+8MPd9o+EuzU72bM9at34LdEkwzNiQYkBAgvkoqOwuA=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  meta = with lib; {
    description = "A wrapper for DNS name resolving or DNS faking";
    homepage = "https://git.samba.org/?p=resolv_wrapper.git;a=summary;";
    license = licenses.bsd3;
    platforms = platforms.linux;
    changelog = "https://git.samba.org/?p=resolv_wrapper.git;a=blob;f=CHANGELOG;hb=HEAD";
  };
}
