{
  buildDunePackage,
  curl,
  lib,
  lwt,
}:

buildDunePackage (finalAttrs: {
  pname = "curl_lwt";
  inherit (curl) version src;

  propagatedBuildInputs = [
    curl
    lwt
  ];

  doCheck = true;

  meta = curl.meta // {
    description = "Bindings to libcurl (lwt variant)";
  };
})
