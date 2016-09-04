{ stdenv, pixie, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "dust-0-91";
  src = fetchFromGitHub {
    owner = "pixie-lang";
    repo = "dust";
    rev = "efe469661e749a71e86858fd006f61464810575a";
    sha256 = "09n57b6haxwask9m8vimv42ikczf7lgfc7m9izjrcqgs0padvfzc";
  };
  buildInputs = [ pixie ];
  patches = [ ./make-paths-configurable.patch ];
  configurePhase = ''
    pixiePath="${pixie}/bin/pixie-vm" \
    basePath="$out/share/dust" \
      substituteAll dust.in dust
    chmod +x dust
  '';
# FIXME: AOT for dust
#  buildPhase = ''
#    find . -name "*.pxi" -exec pixie-vm -c {} \;
#  '';
  installPhase = ''
    mkdir -p $out/bin $out/share/dust
    cp -a src/ run.pxi $out/share/dust
    mv dust $out/bin/dust
  '';

  meta = {
    description = "Provides tooling around pixie, e.g. a nicer repl, running tests and fetching dependencies";
    homepage = src.meta.homepage;
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
