{ buildDunePackage
, ctypes
, dune-configurator
, libffi
, ounit2
, lwt
}:

buildDunePackage rec {
  pname = "ctypes-foreign";

  inherit (ctypes) version src doCheck;

  buildInputs = [ dune-configurator ];

  propagatedBuildInputs = [ ctypes libffi ];

  checkInputs = [ ounit2 lwt ];

  meta = ctypes.meta // {
    description = "Dynamic access to foreign C libraries using Ctypes";
  };
}
