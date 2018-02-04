{ stdenv, lib, fetchFromGitHub, emscripten }:

let version = "0.9.5"; in

stdenv.mkDerivation {
  name = "jsonnet-${version}";
  version = version;

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "google";
    repo = "jsonnet";
    sha256 = "193sa4hdhvml0c32nmdkjii41hbyc5l0zisdn699ar0gaq7yiqan";
  };

  buildInputs = [ emscripten ];

  enableParallelBuilding = true;

  makeFlags = [''EM_CACHE=$(TMPDIR)/.em_cache'' ''all''];

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/share/
    cp jsonnet $out/bin/
    cp libjsonnet.so $out/lib/
    cp -a doc $out/share/doc
    cp -a include $out/include
  '';

  meta = {
    description = "Purely-functional configuration language that helps you define JSON data";
    maintainers = with lib.maintainers; [ benley copumpkin ];
    license = lib.licenses.asl20;
    homepage = https://github.com/google/jsonnet;
    platforms = lib.platforms.unix;
  };
}
