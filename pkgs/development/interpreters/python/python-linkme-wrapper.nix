{ stdenv }:

stdenv.mkDerivation {
  name = "python-linkme-wrapper-1.0";

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/bin
    cat ${./python-linkme-wrapper.sh} >  $out/bin/.python-linkme-wrapper
    chmod +x $out/bin/.python-linkme-wrapper
  '';

  preferLocalBuild = true;
}
