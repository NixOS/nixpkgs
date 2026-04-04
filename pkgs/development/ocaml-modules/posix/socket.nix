{
  buildDunePackage,
  posix-base,
  dune-configurator,
}:

buildDunePackage {
  pname = "posix-socket";

  inherit (posix-base) version src;

  minimalOCamlVersion = "4.12";

  buildInputs = [ dune-configurator ];

  propagatedBuildInputs = [ posix-base ];

  doCheck = true;

  meta = posix-base.meta // {
    description = "Bindings for posix sockets";
  };

}
