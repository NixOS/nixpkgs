{ lib, stdenv, fetchurl, cmake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "uid_wrapper";
  version = "1.2.8";

  src = fetchurl {
    url = "mirror://samba/cwrap/uid_wrapper-${version}.tar.gz";
    sha256 = "0swm9d8l69dw7nbrw6xh7rdy7cfrqflw3hxshicsrhd9v03iwvqf";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  meta = with lib; {
    description = "A wrapper for the user, group and hosts NSS API";
    homepage = "https://git.samba.org/?p=uid_wrapper.git;a=summary;";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
