{
  lib,
  stdenv,
  fetchgit,
  zlib,
}:
let
  lss = fetchgit {
    url = "https://chromium.googlesource.com/linux-syscall-support";
    rev = "v2022.10.12";
    hash = "sha256-rF10v5oH4u9i9vnmFCVVl2Ew3h+QTiOsW64HeB0nRQU=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "breakpad";

  version = "2023.01.27";

  src = fetchgit {
    url = "https://chromium.googlesource.com/breakpad/breakpad";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8msKz0K10r13TwM3oS6GCIlMdf8k8HBKfKJkPmrUrIs=";
  };

  buildInputs = [ zlib ];

  postUnpack = ''
    ln -s ${lss} $sourceRoot/src/third_party/lss
  '';

  meta = with lib; {
    description = "An open-source multi-platform crash reporting system";
    homepage = "https://chromium.googlesource.com/breakpad";
    license = licenses.bsd3;
    maintainers = with maintainers; [ berberman ];
    platforms = platforms.all;
  };
})
