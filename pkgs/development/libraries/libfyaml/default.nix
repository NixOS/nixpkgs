{ stdenv, fetchurl, gnum4 }:

stdenv.mkDerivation rec {
  pname = "libfyaml";
  version = "0.5.7";

  src = fetchurl {
    url = "https://github.com/pantoniou/libfyaml/releases/download/v${version}/libfyaml-${version}.tar.gz";
    sha256 = "143m30f006jsvhikk9nc050hxzqi8xg0sbd88kjrgfpyncdz689j";
  };

  nativeBuildInputs = [ gnum4 ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/pantoniou/libfyaml";
    description = "Fully feature complete YAML parser and emitter, supporting the latest YAML spec and passing the full YAML testsuite";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
