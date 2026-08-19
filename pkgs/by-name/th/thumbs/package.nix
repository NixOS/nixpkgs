{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "thumbs";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "fcsonline";
    repo = "tmux-thumbs";
    rev = finalAttrs.version;
    sha256 = "sha256-XMz1ZOTz2q1Dt4QdxG83re9PIsgvxTTkytESkgKxhGM=";
  };

  cargoHash = "sha256-xvfjWS1QZWrlwytFyWVtjOyB3EPT9leodVLt72yyM4E=";

  patches = [ ./fix.patch ];

  meta = {
    homepage = "https://github.com/fcsonline/tmux-thumbs";
    description = "Lightning fast version of tmux-fingers written in Rust, copy/pasting tmux like vimium/vimperator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ghostbuster91 ];
  };
})
