{ stdenv, lambdabot, mueval, ghc, makeWrapper }:

stdenv.mkDerivation {
  name = "lambdabot-wrapper";

  buildInputs = [ makeWrapper ];

  buildCommand = ''
    makeWrapper "${lambdabot}/bin/lambdabot" "$out/bin/lambdabot" \
      --prefix PATH : "${ghc}/bin:${mueval}/bin"
  '';

  preferLocalBuild = true;

  meta = lambdabot.meta;
}
