{ fetchFromGitHub }:

rec {
  # When you bump this, you should make sure all nemo-extensions
  # are actually using this file since we try to deal with tags
  # like nemo-fileroller-5.6.1 according to upstream's wishes.
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "nemo-extensions";
    rev = version;
    sha256 = "sha256-zuE0SO5VJ2kKjK7JgsSf+wJgfyffTHhfICslEoPKK8Q=";
  };
}
