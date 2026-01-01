{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "thumbs";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "fcsonline";
    repo = "tmux-thumbs";
    rev = version;
    sha256 = "sha256-XMz1ZOTz2q1Dt4QdxG83re9PIsgvxTTkytESkgKxhGM=";
  };

  cargoHash = "sha256-xvfjWS1QZWrlwytFyWVtjOyB3EPT9leodVLt72yyM4E=";

  patches = [ ./fix.patch ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/fcsonline/tmux-thumbs";
    description = "Lightning fast version of tmux-fingers written in Rust, copy/pasting tmux like vimium/vimperator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ghostbuster91 ];
=======
  meta = with lib; {
    homepage = "https://github.com/fcsonline/tmux-thumbs";
    description = "Lightning fast version of tmux-fingers written in Rust, copy/pasting tmux like vimium/vimperator";
    license = licenses.mit;
    maintainers = with maintainers; [ ghostbuster91 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
