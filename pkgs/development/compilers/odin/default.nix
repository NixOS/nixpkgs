{ lib
, fetchFromGitHub
, llvmPackages_13
, makeBinaryWrapper
, libiconv
, MacOSX-SDK
, which
}:

let
  llvmPackages = llvmPackages_13;
  inherit (llvmPackages) stdenv;
in stdenv.mkDerivation rec {
  pname = "odin";
  version = "dev-2024-01";

  src = fetchFromGitHub {
    owner = "odin-lang";
    repo = "Odin";
    rev = version;
    hash = "sha256-ufIpnibY7rd76l0Mh+qXYXkc8W3cuTJ1cbmj4SgSUis=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper which
  ];

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  LLVM_CONFIG = "${llvmPackages.llvm.dev}/bin/llvm-config";

  postPatch = lib.optionalString stdenv.isDarwin ''
    sed -i src/main.cpp \
      -e 's|-syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk|-syslibroot ${MacOSX-SDK}|'
  '' + ''
    sed -i build_odin.sh \
      -e 's/^GIT_SHA=.*$/GIT_SHA=/' \
      -e 's/LLVM-C/LLVM/' \
      -e 's/framework System/lSystem/'
    patchShebangs build_odin.sh
  '';

  dontConfigure = true;

  buildFlags = [
    "release"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp odin $out/bin/odin

    mkdir -p $out/share
    cp -r core $out/share/core
    cp -r vendor $out/share/vendor

    wrapProgram $out/bin/odin \
      --prefix PATH : ${lib.makeBinPath (with llvmPackages; [
        bintools
        llvm
        clang
        lld
      ])} \
      --set-default ODIN_ROOT $out/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "A fast, concise, readable, pragmatic and open sourced programming language";
    homepage = "https://odin-lang.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ luc65r astavie znaniye ];
    platforms = platforms.x86_64 ++ [ "aarch64-darwin" ];
  };
}
