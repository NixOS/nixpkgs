{
  lib,
  fetchzip,
  topkg,
  buildTopkgPackage,
}:

buildTopkgPackage rec {
  pname = "typegist";
  version = "0.0.0";

  minimalOCamlVersion = "5.5.0";

  src = fetchzip {
    url = "https://erratique.ch/software/typegist/releases/typegist-${version}.tbz";
    hash = "sha256-zt37VVZnlxvzw7idYw9v34rNiuJkWG37DqaqkzLDRXI=";
  };

  buildPhase = "${topkg.run} build";

  doCheck = true;

  meta = {
    description = "The essence of OCaml types as values";
    longDescription = ''
      This dynamic type representation can be used to devise generic
      type-indexed functions — value serializers, generators, differs, editors,
      FFI glue, etc. Any accessible type can be described up to the limits
      defined by its public interface.

      Typegist does not model OCaml’s type language in full detail. It focuses
      on a core structural subset decorated with typed-indexed metadata to
      provide an ergonomic interface for both producers and processors of the
      representation.
    '';
    homepage = "https://erratique.ch/software/typegist";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ toastal ];
  };
}
