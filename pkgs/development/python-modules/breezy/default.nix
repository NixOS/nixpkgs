{ lib
, stdenv
, buildPythonPackage
, fetchpatch
, fetchPypi
, cargo
, configobj
, cython
, dulwich
, fastbencode
, fastimport
, pygithub
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
  version = "3.3.4";
  format = "pyproject";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fEEvOfo8YWhx+xuiqD/KNstlso5/K1XJnGY64tkLIwE=";
  };

  patches = [
    # Explicitly track which URLs are used for GitLab
    (fetchpatch {
      url = "https://github.com/breezy-team/breezy/commit/cc9fdf3774253183f726127c2ee191c24640d898.patch";
      hash = "sha256-HTDAW3CPEZ1YBe0wnv6ncWEd0QRHwHawfTplbVDiOGc=";
    })
  ];

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

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
    ++ passthru.optional-dependencies.fastimport
    ++ passthru.optional-dependencies.github;

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
      github = [
        pygithub
      ];
    };
  };

  meta = with lib; {
    description = "Friendly distributed version control system";
    homepage = "https://www.breezy-vcs.org/";
    changelog = "https://github.com/breezy-team/breezy/blob/brz-${version}/doc/en/release-notes/brz-${versions.majorMinor version}.txt";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.marsam ];
    mainProgram = "brz";
  };
}
