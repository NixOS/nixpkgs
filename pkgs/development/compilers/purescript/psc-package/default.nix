# Based on https://github.com/justinwoo/easy-purescript-nix/blob/master/psc-package-simple.nix
{ stdenv, lib, fetchurl, gmp, zlib, libiconv, darwin, installShellFiles }:

let
  dynamic-linker = stdenv.cc.bintools.dynamicLinker;

in
stdenv.mkDerivation rec {
  pname = "psc-package-simple";

  version = "0.6.2";

  src = if stdenv.isDarwin
  then fetchurl {
    url = "https://github.com/purescript/psc-package/releases/download/v0.6.2/macos.tar.gz";
    sha256 = "17dh3bc5b6ahfyx0pi6n9qnrhsyi83qdynnca6k1kamxwjimpcq1";
  }
  else fetchurl {
    url = "https://github.com/purescript/psc-package/releases/download/v0.6.2/linux64.tar.gz";
    sha256 = "1zvay9q3xj6yd76w6qyb9la4jaj9zvpf4dp78xcznfqbnbhm1a54";
  };

  buildInputs = [ gmp zlib ];
  nativeBuildInputs = [ installShellFiles ];

  libPath = lib.makeLibraryPath buildInputs;

  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin

    PSC_PACKAGE=$out/bin/psc-package

    install -D -m555 -T psc-package $PSC_PACKAGE
    chmod u+w $PSC_PACKAGE
  '' + lib.optionalString stdenv.isDarwin ''
    install_name_tool \
      -change /usr/lib/libSystem.B.dylib ${darwin.Libsystem}/lib/libSystem.B.dylib \
      -change /usr/lib/libiconv.2.dylib ${libiconv}/libiconv.2.dylib \
      $PSC_PACKAGE
  '' + lib.optionalString (!stdenv.isDarwin) ''
    patchelf --interpreter ${dynamic-linker} --set-rpath ${libPath} $PSC_PACKAGE
  '' + ''
    chmod u-w $PSC_PACKAGE

    installShellCompletion --cmd psc-package \
      --bash <($PSC_PACKAGE --bash-completion-script $PSC_PACKAGE) \
      --fish <($PSC_PACKAGE --fish-completion-script $PSC_PACKAGE) \
      --zsh <($PSC_PACKAGE --zsh-completion-script $PSC_PACKAGE)
  '';

  meta = with lib; {
    description = "A package manager for PureScript based on package sets";
    mainProgram = "psc-package";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
  };
}
