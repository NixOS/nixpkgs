{ stdenv, lib, fetchFromGitHub, emscripten }:

let version = "0.9.4"; in

stdenv.mkDerivation {
  name = "jsonnet-${version}";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "google";
    repo = "jsonnet";
    sha256 = "1bh9x8d3mxnic31b6gh4drn5l6qpyqfgsn2l48sv0jknhinm1a7l";
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
