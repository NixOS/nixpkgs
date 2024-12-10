{
  llvmPackages,
  lib,
  fetchFromGitHub,
  cmake,
}:

llvmPackages.stdenv.mkDerivation rec {
  pname = "cone";
  version = "unstable-2022-12-12";

  src = fetchFromGitHub {
    owner = "jondgoodwin";
    repo = pname;
    rev = "698bd6afc75777eabbc8ef576d64d683c6a1c5ab";
    sha256 = "0y2s9xgkci8n72v6gnc1i7shr2y3g2sa8fbr25gpxa9ipiq9khg7";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    llvmPackages.llvm
  ];

  # M68k is an experimental target, so not enabled by default
  postPatch = ''
    sed -i CMakeLists.txt \
        -e '/M68k/d'
  '';

  installPhase = ''
    install -Dm755 conec $out/bin/conec
    install -Dm644 libconestd.a $out/lib/libconestd.a
  '';

  meta = with lib; {
    description = "Cone Programming Language";
    mainProgram = "conec";
    homepage = "https://cone.jondgoodwin.com";
    license = licenses.mit;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.all;
  };
}
