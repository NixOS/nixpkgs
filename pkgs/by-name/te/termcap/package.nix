{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  enableStatic ? stdenv.hostPlatform.isStatic,
  enableShared ? !stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation rec {
  pname = "termcap";
  version = "1.3.1";

  src = fetchurl {
    url = "mirror://gnu/termcap/termcap-${version}.tar.gz";
    hash = "sha256-kaDiLlOHykRntbyxjt8cUbkwJi/UZtX9o5bdnSZxkQA=";
  };

  patches = [
    (fetchpatch {
      name = "0001-tparam-replace-write-with-fprintf.patch";
      url = "https://github.com/msys2/MINGW-packages/raw/c6691ad1bd9d4c6823a18068ca0683c3e32ea005/mingw-w64-termcap/0001-tparam-replace-write-with-fprintf.patch";
      hash = "sha256-R9XaLfa8fzQBt+M+uA1AFTvKYCeOWLUD/7GViazXwto=";
    })
  ];

  outputs = [
    "out"
    "dev"
  ];

  enableParallelBuilding = true;

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook ];

  makeFlags = [
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    [
      "-DSTDC_HEADERS"
    ]
    ++ lib.optionals stdenv.cc.isClang [
      "-Wno-implicit-function-declaration"
    ]
  );

  # Library only statically links by default
  postInstall =
    lib.optionalString (!enableStatic) ''
      rm $out/lib/libtermcap.a
    ''
    + lib.optionalString enableShared (
      let
        libName = "lib${pname}${stdenv.hostPlatform.extensions.sharedLibrary}";
        impLibName = "lib${pname}.dll.a";
        winImpLib = lib.optionalString stdenv.hostPlatform.isWindows "-Wl,--out-implib,${impLibName}";
      in
      ''
        ${stdenv.cc.targetPrefix}cc -shared -o ${libName} termcap.o tparam.o version.o ${winImpLib}
        install -Dm644 ${libName} $out/lib
      ''
      + lib.optionalString stdenv.hostPlatform.isWindows ''
        install -Dm644 ${impLibName} $out/lib
      ''
    );

  meta = {
    description = "Terminal feature database";
    homepage = "https://www.gnu.org/software/termutils/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.all;
  };
}
