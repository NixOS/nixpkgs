{
  lib,
  buildDunePackage,
  fetchurl,
  fmt,
<<<<<<< HEAD
  lwt,
}:

buildDunePackage (finalAttrs: {
  pname = "mirage-device";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-device/releases/download/v${finalAttrs.version}/mirage-device-v${finalAttrs.version}.tbz";
    hash = "sha256-BChsZyjygM9uxT3FTmfVUrE3XVtUSkXJ2rhTbqLvVKE=";
=======
  ocaml_lwt,
}:

buildDunePackage rec {
  pname = "mirage-device";
  version = "2.0.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-device/releases/download/v${version}/mirage-device-v${version}.tbz";
    sha256 = "18alxyi6wlxqvb4lajjlbdfkgcajsmklxi9xqmpcz07j51knqa04";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  propagatedBuildInputs = [
    fmt
<<<<<<< HEAD
    lwt
=======
    ocaml_lwt
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  meta = {
    description = "Abstract devices for MirageOS";
    homepage = "https://github.com/mirage/mirage-device";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
