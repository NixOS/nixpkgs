{ stdenv, fetchFromGitHub, pkgconfig, openssl, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "pkcs11-helper-${version}";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "pkcs11-helper";
    rev = "${name}";
    sha256 = "1bfsmy9w2qf7avvs3rsc1ycqczzzw0j2wsqkd2fj4dc1fqzigq2q";
  };

  buildInputs = [ pkgconfig openssl autoreconfHook ];

  meta = with stdenv.lib; {
    homepage = https://www.opensc-project.org/opensc/wiki/pkcs11-helper;
    license = with licenses; [ bsd3 gpl2 ];
    description = "Library that simplifies the interaction with PKCS#11 providers";
    platforms = platforms.unix;
  };
}
