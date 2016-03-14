{ stdenv, pixie, fetchgit }:

stdenv.mkDerivation {
  name = "dust-0-91";
  src = fetchgit {
    url = "https://github.com/pixie-lang/dust.git";
    rev = "efe469661e749a71e86858fd006f61464810575a";
    sha256 = "0krh7ynald3gqv9f17a4kfx7sx8i31l6j1fhd5k8b6m8cid7f9c1";
  };
  buildInputs = [ pixie ];
  patches = [ ./make-paths-configurable.patch ];
  configurePhase = ''
    pixiePath="${pixie}/bin/pxi" \
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
}
