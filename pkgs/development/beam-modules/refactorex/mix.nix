{
  lib,
  beamPackages,
  overrides ? (x: y: { }),
}:

let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages =
    with beamPackages;
    with self;
    {
      bunt = buildMix rec {
        name = "bunt";
        version = "1.0.0";

        src = fetchHex {
          pkg = "bunt";
          version = "${version}";
          sha256 = "dc5f86aa08a5f6fa6b8096f0735c4e76d54ae5c9fa2c143e5a1fc7c1cd9bb6b5";
        };

        beamDeps = [ ];
      };

      credo = buildMix rec {
        name = "credo";
        version = "1.7.5";

        src = fetchHex {
          pkg = "credo";
          version = "${version}";
          sha256 = "f799e9b5cd1891577d8c773d245668aa74a2fcd15eb277f51a0131690ebfb3fd";
        };

        beamDeps = [
          bunt
          file_system
          jason
        ];
      };

      diffie = buildMix rec {
        name = "diffie";
        version = "0.2.0";

        src = fetchHex {
          pkg = "diffie";
          version = "${version}";
          sha256 = "5147cddea7ec6696f83884490024acc506594ad506873cac432d837189f65d1b";
        };

        beamDeps = [ ];
      };

      file_system = buildMix rec {
        name = "file_system";
        version = "1.0.0";

        src = fetchHex {
          pkg = "file_system";
          version = "${version}";
          sha256 = "6752092d66aec5a10e662aefeed8ddb9531d79db0bc145bb8c40325ca1d8536d";
        };

        beamDeps = [ ];
      };

      gen_lsp = buildMix rec {
        name = "gen_lsp";
        version = "0.3.0";

        src = fetchHex {
          pkg = "gen_lsp";
          version = "${version}";
          sha256 = "a087efd4725fab2b41ff1f4557ba62a8cda3d226e671e6d40ff8dc034420a425";
        };

        beamDeps = [
          jason
          nimble_options
          schematic
          typed_struct
        ];
      };

      jason = buildMix rec {
        name = "jason";
        version = "1.4.1";

        src = fetchHex {
          pkg = "jason";
          version = "${version}";
          sha256 = "fbb01ecdfd565b56261302f7e1fcc27c4fb8f32d56eab74db621fc154604a7a1";
        };

        beamDeps = [ ];
      };

      nimble_options = buildMix rec {
        name = "nimble_options";
        version = "1.1.0";

        src = fetchHex {
          pkg = "nimble_options";
          version = "${version}";
          sha256 = "8bbbb3941af3ca9acc7835f5655ea062111c9c27bcac53e004460dfd19008a99";
        };

        beamDeps = [ ];
      };

      schematic = buildMix rec {
        name = "schematic";
        version = "0.3.1";

        src = fetchHex {
          pkg = "schematic";
          version = "${version}";
          sha256 = "52c419b5c405286e2d0369b9ca472b00b850c59a8b0bdf0dd69172ad4418d5ea";
        };

        beamDeps = [ telemetry ];
      };

      sourceror = buildMix rec {
        name = "sourceror";
        version = "1.7.1";

        src = fetchHex {
          pkg = "sourceror";
          version = "${version}";
          sha256 = "cd6f268fe29fa00afbc535e215158680a0662b357dc784646d7dff28ac65a0fc";
        };

        beamDeps = [ ];
      };

      telemetry = buildRebar3 rec {
        name = "telemetry";
        version = "1.2.1";

        src = fetchHex {
          pkg = "telemetry";
          version = "${version}";
          sha256 = "dad9ce9d8effc621708f99eac538ef1cbe05d6a874dd741de2e689c47feafed5";
        };

        beamDeps = [ ];
      };

      typed_struct = buildMix rec {
        name = "typed_struct";
        version = "0.3.0";

        src = fetchHex {
          pkg = "typed_struct";
          version = "${version}";
          sha256 = "c50bd5c3a61fe4e198a8504f939be3d3c85903b382bde4865579bc23111d1b6d";
        };

        beamDeps = [ ];
      };
    };
in
self
