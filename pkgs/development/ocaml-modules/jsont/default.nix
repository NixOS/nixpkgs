{
  lib,
  fetchzip,
  buildTopkgPackage,
  brr,
  bytesrw,
  cmdliner,
}:

buildTopkgPackage rec {
  pname = "jsont";
  version = "0.1.1";

  minimalOCamlVersion = "4.14.0";

  src = fetchzip {
    url = "https://erratique.ch/software/jsont/releases/jsont-${version}.tbz";
    hash = "sha256-bLbTfRVz/Jzuy2LnQeTEHQGojfA34M+Xj7LODpBAVK4=";
  };

  # docs say these dependendencies are optional, but buildTopkgPackage doesn’t
  # handle missing dependencies

  buildInputs = [
    cmdliner
  ];

  propagatedBuildInputs = [
    brr
    bytesrw
  ];

  meta = {
    description = "declarative JSON data manipulation";
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
