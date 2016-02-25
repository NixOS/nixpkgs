{ stdenv, lib, fetchFromGitHub, emscripten }:

let version = "0.8.6"; in

stdenv.mkDerivation {
  name = "jsonnet-${version}";

  srcs = fetchFromGitHub {
    rev = "v${version}";
    owner = "google";
    repo = "jsonnet";
    sha256 = "1dkvm81gi1j02zs00mqshn9i71bcnqbxsm5hh3wwa2y0sffvgkwh";
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
    maintainers = [ lib.maintainers.benley ];
    license = lib.licenses.asl20;
    homepage = https://github.com/google/jsonnet;
  };
}
