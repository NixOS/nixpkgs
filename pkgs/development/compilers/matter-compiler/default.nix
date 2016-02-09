
{ stdenv, lib, bundlerEnv, ruby }:

bundlerEnv {
  name = "matter_compiler-0.5.1";

  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = with lib; {
    description = ''
      Matter Compiler is a API Blueprint AST Media Types to API Blueprint conversion tool.
      It composes an API blueprint from its serialzed AST media-type.
    '';
    homepage    = https://github.com/apiaryio/matter_compiler/;
    license     = licenses.mit;
    maintainers = with maintainers; [ rvlander ];
    platforms   = platforms.unix;
  };
}
