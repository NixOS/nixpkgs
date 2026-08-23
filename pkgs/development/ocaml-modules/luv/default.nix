{
  lib,
  buildDunePackage,
  fetchurl,
  ctypes,
  result,
  alcotest,
  file,
}:

buildDunePackage (finalAttrs: {
  pname = "luv";
  version = "0.5.14";

  src = fetchurl {
    url = "https://github.com/aantron/luv/releases/download/${finalAttrs.version}/luv-${finalAttrs.version}.tar.gz";
    hash =
      {
        "0.5.14" = "sha256-jgG0pQyIds3ZjY4kXAaHxNxNiDrtFhrZxazh+x/arpk=";
        "0.5.12" = "sha256-dp9qCIYqSdROIAQ+Jw73F3vMe7hnkDe8BgZWImNMVsA=";
      }
      ."${finalAttrs.version}";
  };

  patches = lib.optional (lib.versionOlder finalAttrs.version "0.5.14") ./incompatible-pointer-type-fix.diff;

  postConfigure = ''
    substituteInPlace "src/c/vendor/configure/ltmain.sh" --replace-fail /usr/bin/file file
  '';

  nativeBuildInputs = [ file ];
  propagatedBuildInputs = [
    ctypes
    result
  ];
  checkInputs = [ alcotest ];
  doCheck = true;

  meta = {
    homepage = "https://github.com/aantron/luv";
    description = "Binding to libuv: cross-platform asynchronous I/O";
    # MIT-licensed, extra licenses apply partially to libuv vendor
    license = with lib.licenses; [
      mit
      bsd2
      bsd3
      cc-by-sa-40
    ];
    maintainers = with lib.maintainers; [
      locallycompact
      sternenseemann
    ];
  };
})
