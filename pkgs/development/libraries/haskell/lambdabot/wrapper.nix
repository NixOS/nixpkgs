{ stdenv, lambdabot, mueval, makeWrapper }:

stdenv.mkDerivation {
  name = "lambdabot-wrapper";

  buildInputs = [ makeWrapper ];

  buildCommand = ''
    makeWrapper "${lambdabot}/bin/lambdabot" "$out/bin/lambdabot" \
      --prefix PATH : "${mueval}/bin"
  '';

  preferLocalBuild = true;

  meta = {
    description = lambdabot.meta.description;
  };
}

