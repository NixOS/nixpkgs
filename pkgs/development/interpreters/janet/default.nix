{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  nix-update-script,
<<<<<<< HEAD
  pkgsBuildBuild,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  runCommand,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "janet";
<<<<<<< HEAD
  version = "1.40.1";
=======
  version = "1.39.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "janet-lang";
    repo = "janet";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-BV5hVg85QgN8DXiMF2kA3IQNuvWjcsyciiuQP5+c+7c=";
=======
    hash = "sha256-Hd8DueT9f7vmK0QFJdRx7FgZ8BYh5prQyM++5Yb6tg4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  depsBuildBuild = [ pkgsBuildBuild.stdenv.cc ];
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Janet programming language";
    mainProgram = "janet";
    homepage = "https://janet-lang.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      peterhoeg
    ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Janet programming language";
    mainProgram = "janet";
    homepage = "https://janet-lang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [
      peterhoeg
    ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
