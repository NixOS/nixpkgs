{ lib, mkFont, fetchFromGitHub }:

mkFont {
  name = "powerline-fonts";
  version = "2018-11-11";

  src = fetchFromGitHub {
    owner = "powerline";
    repo = "fonts";
    rev = "e80e3eba9091dac0655a0a77472e10f53e754bb0";
    sha256 = "0n8yhc8y1vpiyza58d4fj5lyf03ncymrxc81a31crlbzlqvwwrqq";
  };

  meta = with lib; {
    homepage = "https://github.com/powerline/fonts";
    description = "Patched fonts for Powerline users";
    longDescription = ''
      Pre-patched and adjusted fonts for usage with the Powerline plugin.
    '';
    license = with licenses; [ asl20 free ofl ];
    platforms = platforms.all;
    maintainers = with maintainers; [ malyn ];
  };
}
