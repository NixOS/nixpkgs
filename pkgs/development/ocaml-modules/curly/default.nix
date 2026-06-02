{
  stdenv,
  lib,
  buildDunePackage,
  fetchurl,
  ocaml,
  result,
  alcotest,
  cohttp-lwt-unix,
  curl,
  cacert,
}:

buildDunePackage (finalAttrs: {
  pname = "curly";
  version = "0.3.0";

  minimalOCamlVersion = "4.03";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/rgrinberg/curly/releases/download/${finalAttrs.version}/curly-${finalAttrs.version}.tbz";
    hash = "sha256-Qn/PKBNOcMt3dk2f7uJD8x0yo4RHobXSjTQck7fcXTw=";
  };

  propagatedBuildInputs = [ result ];
  nativeCheckInputs = [ cacert ];
  checkInputs = [
    alcotest
    cohttp-lwt-unix
  ];
  # test dependencies are only available for >= 4.08
  # https://github.com/mirage/ca-certs/issues/16
  doCheck =
    lib.versionAtLeast ocaml.version "4.08"
    # Some test fails in macOS sandbox
    # > Fatal error: exception Unix.Unix_error(Unix.EPERM, "bind", "")
    && !stdenv.hostPlatform.isDarwin;

  postPatch = ''
    substituteInPlace src/curly.ml \
      --replace "exe=\"curl\"" "exe=\"${curl}/bin/curl\""
    substituteInPlace test/test_curly.ml \
      --replace-fail "let body_header b = [\"content-length\", string_of_int (String.length b)]" \
                     "let body_header b = [\"connection\", \"keep-alive\"; \"content-length\", string_of_int (String.length b)]"
  '';

  meta = {
    description = "Curly is a brain dead wrapper around the curl command line utility";
    homepage = "https://github.com/rgrinberg/curly";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
})
