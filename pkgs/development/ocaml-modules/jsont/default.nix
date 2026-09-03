{
  lib,
  fetchzip,
  ocaml,
  topkg,
  buildTopkgPackage,
  withBrr ? true,
  brr,
  withBytesrw ? true,
  bytesrw,
  withCmdliner ? true,
  cmdliner,
  withTypegist ? lib.versionAtLeast ocaml.version "5.5",
  typegist,
}:

buildTopkgPackage rec {
  pname = "jsont";
  version = "0.4.0";

  minimalOCamlVersion = "4.14.0";

  src = fetchzip {
    url = "https://erratique.ch/software/jsont/releases/jsont-${version}.tbz";
    hash = "sha256-2L7YaPXn4PzGl/3XwuwvpQTr4aiS85Hm1HNofuaK7DY=";
  };

  buildInputs = lib.optional withCmdliner cmdliner;

  propagatedBuildInputs =
    lib.optional withBrr brr
    ++ lib.optional withBytesrw bytesrw
    ++ lib.optional withTypegist typegist;

  buildPhase = ''
    runHook preBuild
    ${topkg.run} build ${
      lib.escapeShellArgs [
        "--with-brr"
        (lib.boolToString withBrr)

        "--with-bytesrw"
        (lib.boolToString withBytesrw)

        "--with-cmdliner"
        (lib.boolToString withCmdliner)

        "--with-typegist"
        (lib.boolToString withTypegist)
      ]
    }
    runHook postBuild
  '';

  meta = {
    description = "Declarative JSON data manipulation";
    longDescription = ''
      Jsont is an OCaml library for declarative JSON data manipulation. it
      provides:

      • Combinators for describing JSON data using the OCaml values of your
        choice. The descriptions can be used by generic functions to decode,
        encode, query and update JSON data without having to construct a
        generic JSON representation
      • A JSON codec with optional text location tracking and best-effort
        layout preservation. The codec is compatible with effect-based
        concurrency.

      The descriptions are independent from the codec and can be used by
      third-party processors or codecs.
    '';
    homepage = "https://erratique.ch/software/jsont";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ toastal ];
  };
}
