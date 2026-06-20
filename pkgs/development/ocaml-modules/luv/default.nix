{
  lib,
  buildDunePackage,
  fetchurl,
  ctypes,
  result,
  alcotest,
  file,
}:

let
  generic =
    {
      version,
      sha256,
    }:
    buildDunePackage (finalAttrs: {
      pname = "luv";
      inherit version;

      src = fetchurl {
        url = "https://github.com/aantron/luv/releases/download/${finalAttrs.version}/luv-${finalAttrs.version}.tar.gz";
        inherit sha256;
      };

      patches = lib.optional (lib.versionOlder version "0.5.14") ./incompatible-pointer-type-fix.diff;

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
    });
in
{
  luv-0-5-12 = generic {
    version = "0.5.12";
    sha256 = "sha256-dp9qCIYqSdROIAQ+Jw73F3vMe7hnkDe8BgZWImNMVsA=";
  };
  luv = generic {
    version = "0.5.14";
    sha256 = "sha256-jgG0pQyIds3ZjY4kXAaHxNxNiDrtFhrZxazh+x/arpk=";
  };
}
