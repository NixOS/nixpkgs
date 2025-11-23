{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  nix-update-script,
  runCommand,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "janet";
  version = "1.39.1";

  src = fetchFromGitHub {
    owner = "janet-lang";
    repo = "janet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Hd8DueT9f7vmK0QFJdRx7FgZ8BYh5prQyM++5Yb6tg4=";
  };

  postPatch = ''
    substituteInPlace janet.1 \
      --replace /usr/local/ $out/
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # error: Socket is not connected
    substituteInPlace meson.build \
      --replace "'test/suite-ev.janet'," ""
  '';

  nativeBuildInputs = [
    meson
    ninja
  ];

  mesonBuildType = "release";
  mesonFlags = [ "-Dgit_hash=release" ];

  doCheck = true;

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/janet -e '(+ 1 2 3)'
  '';

  passthru = {
    tests.run =
      runCommand "janet-test-run"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          echo "(+ 1 2 3)" | janet | tail -n 1 > arithmeticTest.txt;
          diff -U3 --color=auto <(cat arithmeticTest.txt) <(echo "6");

          echo "(print \"Hello, World!\")" | janet | tail -n 2 > ioTest.txt;
          diff -U3 --color=auto <(cat ioTest.txt) <(echo -e "Hello, World!\nnil");

          touch $out;
        '';
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Janet programming language";
    mainProgram = "janet";
    homepage = "https://janet-lang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [
      peterhoeg
    ];
    platforms = platforms.all;
  };
})
