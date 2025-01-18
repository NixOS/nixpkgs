{
  lib,
  buildDunePackage,
  fetchurl,
  fmt,
  ocaml_lwt,
}:

buildDunePackage rec {
  pname = "mirage-device";
  version = "2.0.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-device/releases/download/v${version}/mirage-device-v${version}.tbz";
    sha256 = "18alxyi6wlxqvb4lajjlbdfkgcajsmklxi9xqmpcz07j51knqa04";
  };

  propagatedBuildInputs = [
    fmt
    ocaml_lwt
  ];

  meta = with lib; {
    description = "Abstract devices for MirageOS";
    homepage = "https://github.com/mirage/mirage-device";
    license = licenses.isc;
    maintainers = [ maintainers.vbgl ];
  };
}
