{ stdenv, lib, buildDunePackage, fetchurl, ocaml
, result, alcotest, cohttp-lwt-unix, odoc, curl, cacert
}:

buildDunePackage rec {
  pname = "curly";
  version = "0.2.0";

  minimumOCamlVersion = "4.02";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/rgrinberg/curly/releases/download/${version}/curly-${version}.tbz";
    sha256 = "07vqdrklar0d5i83ip7sjw2c1v18a9m3anw07vmi5ay29pxzal6k";
  };

  propagatedBuildInputs = [ result ];
  checkInputs = [ alcotest cohttp-lwt-unix cacert ];
  # test dependencies are only available for >= 4.08
  # https://github.com/mirage/ca-certs/issues/16
  doCheck = lib.versionAtLeast ocaml.version "4.08"
    # Some test fails in macOS sandbox
    # > Fatal error: exception Unix.Unix_error(Unix.EPERM, "bind", "")
    && !stdenv.isDarwin;

  postPatch = ''
    substituteInPlace src/curly.ml \
      --replace "exe=\"curl\"" "exe=\"${curl}/bin/curl\""
    '';

  meta = with lib; {
    description = "Curly is a brain dead wrapper around the curl command line utility";
    homepage = "https://github.com/rgrinberg/curly";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
  };
}

