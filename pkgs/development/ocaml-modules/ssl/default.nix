{ lib, buildDunePackage, fetchFromGitHub, pkg-config, openssl
, dune-configurator }:

buildDunePackage rec {
  pname = "ssl";
  version = "0.5.10";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ssl";
    rev = "v${version}";
    sha256 = "1rszqiqayh67xlwd5411k8vib47x9kapdr037z1majd2c14z3kcb";
  };

  useDune2 = true;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [openssl];

  meta = {
    homepage = "http://savonet.rastageeks.org/";
    description = "OCaml bindings for libssl ";
    license = "LGPL+link exception";
    maintainers = [
      lib.maintainers.maggesi
      lib.maintainers.anmonteiro
      lib.maintainers.dandellion
    ];
  };
}
