{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, ogg, libtheora }:

buildDunePackage rec {
  pname = "theora";
  version = "0.4.0";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-theora";
    rev = "v${version}";
    sha256 = "1sggjmlrx4idkih1ddfk98cgpasq60haj4ykyqbfs22cmii5gpal";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ ogg libtheora ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-theora";
    description = "Bindings to libtheora";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
