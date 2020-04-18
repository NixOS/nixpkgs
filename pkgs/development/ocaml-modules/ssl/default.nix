{ lib, buildDunePackage, fetchFromGitHub, pkg-config, openssl }:

buildDunePackage rec {
  pname = "ssl";
  version = "0.5.9";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ssl";
    rev = version;
    sha256 = "04h02rvzrwp886n5hsx84rnc9b150iggy38g5v1x1rwz3pkdnmf0";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [openssl];

  meta = {
    homepage = "http://savonet.rastageeks.org/";
    description = "OCaml bindings for libssl ";
    license = "LGPL+link exception";
    maintainers = [
      lib.maintainers.maggesi
    ];
  };
}
