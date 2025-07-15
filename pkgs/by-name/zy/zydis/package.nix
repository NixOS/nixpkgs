{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  cmake,
  python3,
}:

let
  zycore = callPackage ./zycore.nix {
    inherit stdenv fetchFromGitHub cmake;
  };
in
stdenv.mkDerivation rec {
  pname = "zydis";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "zyantific";
    repo = "zydis";
    rev = "v${version}";
    hash = "sha256-6J4pTUm3xQXwlQNBldjXVWRcse+auSFJtxGWaPRVzLg=";
  };

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ zycore ];
  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  doCheck = true;
  nativeCheckInputs = [ python3 ];
  passthru = { inherit zycore; };

  meta = {
    homepage = "https://zydis.re/";
    changelog = "https://github.com/zyantific/zydis/releases/tag/v${version}";
    description = "Fast and lightweight x86/x86-64 disassembler library";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jbcrail
      athre0z
    ];
    platforms = lib.platforms.all;
  };
}
