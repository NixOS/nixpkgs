{ lib
, buildDunePackage
, tezos-stdlib
, tezos-protocol-compiler
, tezos-protocol-updater
, tezos-protocol-environment
, tezos-shell
, protocol-name
}:

rec {
  protocol = buildDunePackage {
    pname = "tezos-protocol-${protocol-name}";
    inherit (tezos-stdlib) version useDune2;
    src = "${tezos-stdlib.base_src}/src";

    strictDeps = true;

    nativeBuildInputs = [
      tezos-protocol-compiler
    ];

    doCheck = true;

    meta = tezos-stdlib.meta // {
      description = "Tezos/Protocol: economic-protocol definition";
    };
  };

  protocol-parameters = buildDunePackage {
    pname = "tezos-protocol-${protocol-name}-parameters";
    inherit (tezos-stdlib) version useDune2;
    src = "${tezos-stdlib.base_src}/src";

    strictDeps = true;

    buildInputs = [
      protocol
      tezos-protocol-environment
    ];

    doCheck = true;

    meta = tezos-stdlib.meta // {
      description = "Tezos/Protocol: parameters";
    };
  };

  embedded-protocol = buildDunePackage {
    pname = "tezos-embedded-protocol-${protocol-name}";
    inherit (tezos-stdlib) version useDune2;
    src = "${tezos-stdlib.base_src}/src";

    strictDeps = true;

    nativeBuildInputs = [
      tezos-protocol-compiler
    ];

    buildInputs = [
      tezos-protocol-updater
    ];

    propagatedBuildInputs = [
      protocol
    ];

    doCheck = true;

    meta = tezos-stdlib.meta // {
      description = "Tezos/Protocol: economic-protocol definition, embedded in `tezos-node`";
    };
  };

  protocol-plugin = buildDunePackage {
    pname = "tezos-protocol-plugin-${protocol-name}";
    inherit (tezos-stdlib) version useDune2;
    src = "${tezos-stdlib.base_src}/src";

    strictDeps = true;

    buildInputs = [
      embedded-protocol
      protocol
      tezos-shell
    ];

    doCheck = true;

    meta = tezos-stdlib.meta // {
      description = "Tezos/Protocol: protocol plugin registerer";
    };
  };

  protocol-plugin-registerer = buildDunePackage {
    pname = "tezos-protocol-plugin-${protocol-name}-registerer";
    inherit (tezos-stdlib) version useDune2;
    src = "${tezos-stdlib.base_src}/src";

    strictDeps = true;

    buildInputs = [
      protocol
      embedded-protocol
      tezos-shell
    ];

    propagatedBuildInputs = [
      protocol-plugin
    ];

    doCheck = true;

    meta = tezos-stdlib.meta // {
      description = "Tezos/Protocol: protocol plugin registerer";
    };
  };
}
