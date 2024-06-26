{
  stdenv,
  lib,
  darwin,
  fetchFromGitHub,
  buildDunePackage,
  ocaml,
  cppo,
  camlp-streams,
  dune-site,
  version ? if lib.versionAtLeast ocaml.version "4.08" then "2.0.0" else "1.0.2",
}:

let
  params = {
    "1.0.2" =
      lib.throwIf (lib.versionAtLeast ocaml.version "5.0")
        "camomile 1 is not available for OCaml ${ocaml.version}"
        {
          src = fetchFromGitHub {
            owner = "yoriyuki";
            repo = "camomile";
            rev = version;
            sha256 = "00i910qjv6bpk0nkafp5fg97isqas0bwjf7m6rz11rsxilpalzad";
          };

          nativeBuildInputs = [ cppo ];

          configurePhase = ''
            runHook preConfigure
            ocaml configure.ml --share $out/share/camomile
            runHook postConfigure
          '';

          postInstall = ''
            echo "version = \"${version}\"" >> $out/lib/ocaml/${ocaml.version}/site-lib/camomile/META
          '';

        };

    "2.0.0" = {
      src = fetchFromGitHub {
        owner = "ocaml-community";
        repo = "camomile";
        rev = "v${version}";
        hash = "sha256-HklX+VPD0Ta3Knv++dBT2rhsDSlDRH90k4Cj1YtWIa8=";
      };

      nativeBuildInputs = lib.optional stdenv.isDarwin darwin.sigtool;

      propagatedBuildInputs = [
        camlp-streams
        dune-site
      ];
    };
  };
in

buildDunePackage (
  params."${version}"
  // {
    pname = "camomile";
    inherit version;

    meta = {
      homepage = "https://github.com/ocaml-community/Camomile";
      maintainers = [ lib.maintainers.vbgl ];
      license = lib.licenses.lgpl21;
      description = "Unicode library for OCaml";
    };
  }
)
