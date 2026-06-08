# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation {
  pname = "python314-docs-text";
  version = "3.14";

  src = fetchurl {
    url = "https://docs.python.org/3.14/archives/python-3.14-docs-text.tar.bz2";
    sha256 = "1w8zl9pymsfviiw7iqz86liwnvfh1093syk3vkpvsdmvsa9acwyf";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python314
    cp -R ./ $out/share/doc/python314/text
  '';
  meta = {
    maintainers = with lib.maintainers; [
      panicgh
    ];
  };
}
