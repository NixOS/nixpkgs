{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, ogg, speex }:

buildDunePackage rec {
  pname = "speex";
  version = "0.4.1";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-speex";
    rev = "v${version}";
    sha256 = "0p4ip37kihlz9qy604llak2kzd00g45ix1yiihnrri2nm01scfab";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ ogg speex.dev ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-speex";
    description = "Bindings to libspeex";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
