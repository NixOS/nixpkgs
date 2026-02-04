{
  stdenv,
}:

stdenv.mkDerivation {
  name = "convertyml";
  src = [ ./. ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src/convertyml.sh $out/bin/convertyml
    chmod +x $out/bin/convertyml
  '';
}
