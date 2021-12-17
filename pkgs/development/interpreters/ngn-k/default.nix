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
  version = "unstable-2021-08-30";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ngn";
    repo = "k";
    rev = "3e2bcb81c723e268015818570f2805547114b5dd";
    sha256 = "0b16971xgf0sgx7qf41dilrpz02jnas61gfwkyvbxv18874w5vap";
  };

  patches = [
    ./repl-license-path.patch
  ];

  postPatch = ''
    # make self-reference for LICENSE
    substituteAllInPlace repl.k

    # don't use hardcoded /bin/sh
    for f in repl.k m.c;do
      substituteInPlace "$f" --replace "/bin/sh" "${runtimeShell}"
    done
  '';

  makeFlags = [ "-e" ];
  buildFlags = [ "k" ];
  checkTarget = "t";
  inherit doCheck;

  installPhase = ''
    runHook preInstall
    install -Dm755 k "$out/bin/k"
    install -Dm755 repl.k "$out/bin/k-repl"
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
