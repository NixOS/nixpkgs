{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "breakpad-2018-07-06";
  
  src = fetchgit {
    url = "https://chromium.googlesource.com/breakpad/breakpad";
    rev = "89e7a8615f3d39c802ce27c21ce62646f10291ef";
    sha256 = "088x3jq5snyqk16fshppncm71ki68c5sj6fpd87rb8zkp1nb0dy9";
  };

  breakpad_lss = fetchgit {
    url = "https://chromium.googlesource.com/linux-syscall-support";
    rev = "a89bf7903f3169e6bc7b8efc10a73a7571de21cf";
    sha256 = "0mrahl4d2jn6ngnpj9jd5818fdvs5sgnmv1c591w0rhma7qfmcvx";
  };

  enableParallelBuilding = true;

  prePatch = ''
    cp -r $breakpad_lss src/third_party/lss
    chmod +w -R src/third_party/lss
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
