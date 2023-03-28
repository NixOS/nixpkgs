{ lib
, stdenv
, buildPythonPackage
, fetchPypi
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
, setuptools-gettext
, setuptools-rust
, testers
}:

buildPythonPackage rec {
  pname = "breezy";
  version = "3.3.2";
  format = "pyproject";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TqaUn8uwdrl4VFsJn6xoq6011voYmd7vT2uCo9uiV8E=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  cargoHash = "sha256-xYZh/evNp036/wRlNWWUYeD2EkleM+OeY4qbYMCE00I=";

  nativeBuildInputs = [
    cython
    installShellFiles
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
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
    license = licenses.gpl2Only;
    maintainers = [ maintainers.marsam ];
    mainProgram = "brz";
  };
}
