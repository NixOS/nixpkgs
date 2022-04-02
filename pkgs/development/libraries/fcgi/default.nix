{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "fcgi";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "FastCGI-Archives";
    repo = "fcgi2";
    rev = version;
    sha256 = "1jhz6jfwv5kawa8kajvg18nfwc1b30f38zc0lggszd1vcmrwqkz1";
  };

  nativeBuildInputs = [ autoreconfHook ];

  postInstall = "ln -s . $out/include/fastcgi";

  meta = with lib; {
    description = "A language independent, scalable, open extension to CG";
    homepage = "https://fastcgi-archives.github.io/"; # Formerly http://www.fastcgi.com/
    license = "FastCGI see LICENSE.TERMS";
    platforms = platforms.all;
  };
}
