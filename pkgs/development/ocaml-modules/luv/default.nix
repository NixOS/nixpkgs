{ lib, buildDunePackage, ocaml, fetchurl, libuv
, ctypes, result
, alcotest
, file
}:

buildDunePackage rec {
  pname = "luv";
  version = "0.5.13";

  minimalOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/aantron/luv/releases/download/${version}/luv-${version}.tar.gz";
    hash = "sha256-WaYWvOZYG9ftQn3WpkD/NZ8qVO7bXetf7rNUMXVsIlI=";
  };

  postConfigure = ''
    for f in src/c/vendor/configure/{ltmain.sh,configure}; do
      substituteInPlace "$f" --replace /usr/bin/file file
    done
  '';

  env.LUV_USE_SYSTEM_LIBUV = "yes";

  nativeBuildInputs = [ file ];
  buildInputs = [ libuv ];
  propagatedBuildInputs = [ ctypes result ];
  checkInputs = [ alcotest ];
  # Alcotest depends on fmt that needs 4.08 or newer
  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = with lib; {
    homepage = "https://github.com/aantron/luv";
    description = "Binding to libuv: cross-platform asynchronous I/O";
    changelog = "https://github.com/aantron/luv/releases/tag/${version}";
    # MIT-licensed, extra licenses apply partially to libuv vendor
    license = with licenses; [ mit bsd2 bsd3 cc-by-sa-40 ];
    maintainers = with maintainers; [ locallycompact sternenseemann ];
  };
}
