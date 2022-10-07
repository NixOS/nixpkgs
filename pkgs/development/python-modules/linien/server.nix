{ callPackage
, click
, cma
, myhdl
, pylpsd
, pyrp3
}:

callPackage ./common.nix {
  # The server is usually installed by the GUI on a Redpitaya machine where
  # there's no Nix available by default. The server also includes bash scripts
  # to start and stop it, along with authentication environment variables
  # passed from the client to the server when it connects via ssh to it.
  # Ideally upstream would have changed the design of the server so it'd work
  # with systemd and make the authentication work with a better technology then
  # environment variables.
  propagatedBuildInputs = [
    click
    cma
    myhdl
    pylpsd
    pyrp3
  ];
} "server"
