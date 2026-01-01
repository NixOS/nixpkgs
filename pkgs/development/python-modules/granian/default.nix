{
  lib,
<<<<<<< HEAD
  fetchurl,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  fetchFromGitHub,
  rustPlatform,
  cacert,
  buildPythonPackage,
  uvloop,
  click,
  setproctitle,
  watchfiles,
  versionCheckHook,
  pytestCheckHook,
  pytest-asyncio,
  websockets,
  httpx,
  sniffio,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "granian";
<<<<<<< HEAD
  version = "2.6.0";
=======
  version = "2.5.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emmett-framework";
    repo = "granian";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Jj75ycr9Y0aCTP5YGzd6um/7emWKqqegUDB7HpTfTcM=";
=======
    hash = "sha256-XSDBSl7QWqIN5u48z4H5yPHR+ltRmmmrP0JSmvcCcsA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # Granian forces a custom allocator for all the things it runs,
  # which breaks some libraries in funny ways. Make it not do that,
  # and allow the final application to make the allocator decision
  # via LD_PRELOAD or similar.
  patches = [
<<<<<<< HEAD
    (fetchurl {
      # Refresh expired TLS certificates for tests
      url = "https://github.com/emmett-framework/granian/commit/189f1bed2effb4a8a9cba07b2c5004e599a6a890.patch";
      hash = "sha256-7FgVR7/lAh2P5ptGx6jlFzWuk24RY7wieN+aLaAEY+c=";
    })
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ./no-alloc.patch
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
<<<<<<< HEAD
    hash = "sha256-Q7BWwvkK5rRuhVobxW4qXLo6tnusOaQYN8mBoNVoulw=";
=======
    hash = "sha256-zQAHJcBWNx5IT/t2wtm7UeOfVNnvfowcp137TePnwiM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  dependencies = [
    click
  ];

  optional-dependencies = {
    pname = [ setproctitle ];
    reload = [ watchfiles ];
    # rloop = [ rloop ]; # not packaged
    uvloop = [ uvloop ];
  };

  nativeCheckInputs = [
    versionCheckHook
    pytestCheckHook
    pytest-asyncio
    websockets
    httpx
    sniffio
  ];

  preCheck = ''
    # collides with the one installed in $out
    rm -rf granian/
  '';

  # needed for checks
  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  __darwinAllowLocalNetworking = true;

  enabledTestPaths = [ "tests/" ];

<<<<<<< HEAD
  disabledTests = [
    # SSLCertVerificationError: certificate verify failed: certificate has expired
    "test_asgi_ws_scope"
    "test_rsgi_ws_scope"
  ];

  # This is a measure of last resort. Granian tests fully lock up
  # on shutdown in >90% of cases, which makes the whole thing
  # impossible to build without restarting it double digits
  # numbers of times. The issue has not been fully identified,
  # and upstream claims it does not exist.
  # FIXME: root cause and fix this.
  doCheck = false;

  pythonImportsCheck = [ "granian" ];

=======
  pythonImportsCheck = [ "granian" ];

  versionCheckProgramArg = "--version";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust HTTP server for Python ASGI/WSGI/RSGI applications";
    homepage = "https://github.com/emmett-framework/granian";
    changelog = "https://github.com/emmett-framework/granian/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    mainProgram = "granian";
    maintainers = with lib.maintainers; [
      lucastso10
      pbsds
    ];
    platforms = lib.platforms.unix;
  };
}
