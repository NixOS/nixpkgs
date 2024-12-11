{
  lib,
  buildDunePackage,
  ocaml,
  fetchurl,
  ctypes,
  result,
  alcotest,
  file,
}:

buildDunePackage rec {
  pname = "luv";
  version = "0.5.12";

  minimalOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/aantron/luv/releases/download/${version}/luv-${version}.tar.gz";
    sha256 = "sha256-dp9qCIYqSdROIAQ+Jw73F3vMe7hnkDe8BgZWImNMVsA=";
  };

  patches = [
    # backport of patch to fix incompatible pointer type. remove next update
    # https://github.com/aantron/luv/commit/ad7f953fccb8732fe4eb9018556e8d4f82abf8f2
    ./incompatible-pointer-type-fix.diff
  ];

  postConfigure = ''
    for f in src/c/vendor/configure/{ltmain.sh,configure}; do
      substituteInPlace "$f" --replace /usr/bin/file file
    done
  '';

  nativeBuildInputs = [ file ];
  propagatedBuildInputs = [
    ctypes
    result
  ];
  checkInputs = [ alcotest ];
  # Alcotest depends on fmt that needs 4.08 or newer
  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = with lib; {
    homepage = "https://github.com/aantron/luv";
    description = "Binding to libuv: cross-platform asynchronous I/O";
    # MIT-licensed, extra licenses apply partially to libuv vendor
    license = with licenses; [
      mit
      bsd2
      bsd3
      cc-by-sa-40
    ];
    maintainers = with maintainers; [
      locallycompact
      sternenseemann
    ];
  };
}
