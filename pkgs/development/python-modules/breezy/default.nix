{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, cargo
, configobj
, cython
, dulwich
, fastbencode
, fastimport
, libiconv
, merge3
, patiencediff
, pyyaml
, urllib3
, breezy
, launchpadlib
, testtools
, pythonOlder
, installShellFiles
, rustPlatform
, rustc
, setuptools-gettext
, setuptools-rust
, testers
}:

buildPythonPackage rec {
  pname = "breezy";
<<<<<<< HEAD
  version = "3.3.4";
=======
  version = "3.3.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-fEEvOfo8YWhx+xuiqD/KNstlso5/K1XJnGY64tkLIwE=";
=======
    hash = "sha256-TqaUn8uwdrl4VFsJn6xoq6011voYmd7vT2uCo9uiV8E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

<<<<<<< HEAD
=======
  cargoHash = "sha256-xYZh/evNp036/wRlNWWUYeD2EkleM+OeY4qbYMCE00I=";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    cython
    installShellFiles
    rustPlatform.cargoSetupHook
    cargo
    rustc
    setuptools-gettext
    setuptools-rust
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  propagatedBuildInputs = [
    configobj
    dulwich
    fastbencode
    merge3
    patiencediff
    pyyaml
    urllib3
  ] ++ passthru.optional-dependencies.launchpad
    ++ passthru.optional-dependencies.fastimport;

  nativeCheckInputs = [
    testtools
  ];

  # multiple failures on sandbox
  doCheck = false;

  checkPhase = ''
    runHook preCheck

    HOME=$TMPDIR $out/bin/brz --no-plugins selftest

    runHook postCheck
  '';

  postInstall = ''
    wrapProgram $out/bin/brz --prefix PYTHONPATH : "$PYTHONPATH"

    # symlink for bazaar compatibility
    ln -s "$out/bin/brz" "$out/bin/bzr"

    installShellCompletion --cmd brz --bash contrib/bash/brz
  '';

  pythonImportsCheck = [
    "breezy"
    "breezy.bzr.rio"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = breezy;
      command = "HOME=$TMPDIR brz --version";
    };
    optional-dependencies = {
      launchpad = [
        launchpadlib
      ];
      fastimport = [
        fastimport
      ];
    };
  };

  meta = with lib; {
    description = "Friendly distributed version control system";
    homepage = "https://www.breezy-vcs.org/";
<<<<<<< HEAD
    changelog = "https://github.com/breezy-team/breezy/blob/brz-${version}/doc/en/release-notes/brz-${versions.majorMinor version}.txt";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl2Only;
    maintainers = [ maintainers.marsam ];
    mainProgram = "brz";
  };
}
