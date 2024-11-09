{ lib, stdenv, fetchurl, trousers, openssl, opencryptoki, perl }:

let
  version = "1.3.9.1";
in
stdenv.mkDerivation rec {
  pname = "tpm-tools";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/trousers/tpm-tools/${version}/${pname}-${version}.tar.gz";
    sha256 = "0s7srgghykxnlb1g4izabzf2gfb1knxc0nzn6bly49h8cpi19dww";
  };

  sourceRoot = ".";

  patches = [
    (fetchurl {
      url = "https://sources.debian.org/data/main/t/tpm-tools/1.3.9.1-0.1/debian/patches/05-openssl1.1_fix_data_mgmt.patch";
      sha256 = "161yysw4wgy3spsz6p1d0ib0h5pnrqm8bdh1l71c4hz6a6wpcyxj";
    })
  ];

  nativeBuildInputs = [ perl ];
  buildInputs = [ trousers openssl opencryptoki ];

  meta = with lib; {
    description = "Management tools for TPM hardware";
    longDescription = ''
      tpm-tools is an open-source package designed to enable user and
      application enablement of Trusted Computing using a Trusted Platform
      Module (TPM), similar to a smart card environment.
    '';
    homepage    = "https://sourceforge.net/projects/trousers/files/tpm-tools/";
    license     = licenses.cpl10;
    maintainers = [ maintainers.ak ];
    platforms   = platforms.unix;
  };
}

