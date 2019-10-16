{ build-idris-package
, fetchFromGitHub
, contrib
, lib
, chez
, optimized ? true
}:
build-idris-package rec {
  name = "idris2";
  version = "unstable-2019-10-13";

  idrisDeps = [ contrib ];

  extraBuildInputs = [ chez ];

  src = fetchFromGitHub {
    owner = "edwinb";
    repo = name;
    rev = "4e019d80937a2209cc920bb651fd088b12406463";
    sha256 = "0y3dp2llbzdiwmm6x737srz7n441c3rjx7f1wpc4bqqmc1xh0n9m";
  };

  buildPhase = ''
    env PREFIX="$out" make install
  '';

  patches =
    # If we want an optimized binary (mentioned in the README)
    lib.optional optimized ./0001-optimization.patch
    # The Nix sandbox blocks the network tests, so we patch them out.
    ++ [ ./0010-disable-network-test.patch ];

  meta = with lib; {
    description = "A dependently typed programming language, a successor to Idris";
    license = licenses.bsd3;
    maintainers = with maintainers; [ synthetica ];
  };
}
