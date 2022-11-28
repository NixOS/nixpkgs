{ lib
, stdenv
, stdenvNoLibs
, fetchFromGitea
, runtimeShell
, doCheck ? stdenv.hostPlatform == stdenv.buildPlatform
}:

let
  # k itself is compiled with -ffreestanding, but tests require a libc
  useStdenv = if doCheck then stdenv else stdenvNoLibs;
in

useStdenv.mkDerivation {
  pname = "ngn-k";
  version = "unstable-2022-11-27";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ngn";
    repo = "k";
    rev = "79834b6b9be2a23eec8027d0a2ce11e29f01959c";
    sha256 = "0dczfyqf33mwxfly39xsgwwgjqqm6pjyrlr6gx04zg8n4ch11zhl";
  };

  patches = [
    ./repl-license-path.patch
  ];

  postPatch = ''
    patchShebangs --build a19/a.sh a20/a.sh a21/a.sh dy/a.sh e/a.sh

    # don't use hardcoded /bin/sh
    for f in repl.k repl-bg.k m.c;do
      substituteInPlace "$f" --replace "/bin/sh" "${runtimeShell}"
    done
  '';

  makeFlags = [ "-e" ];
  buildFlags = [ "k" "libk.so" ];
  checkTarget = "t";
  inherit doCheck;

  outputs = [ "out" "dev" "lib" ];

  # TODO(@sternenseemann): package bulgarian translation
  installPhase = ''
    runHook preInstall
    install -Dm755 k "$out/bin/k"
    install -Dm755 repl.k "$out/bin/k-repl"
    install -Dm755 libk.so "$lib/lib/libk.so"
    install -Dm644 k.h "$dev/include/k.h"
    install -Dm644 LICENSE -t "$out/share/ngn-k"
    substituteInPlace "$out/bin/k-repl" --replace "#!k" "#!$out/bin/k"
    runHook postInstall
  '';

  meta = {
    description = "A simple fast vector programming language";
    homepage = "https://codeberg.org/ngn/k";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.sternenseemann ];
    platforms = [ "x86_64-linux" "x86_64-freebsd" ];
  };
}
