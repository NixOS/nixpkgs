{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  stdenv,
  replaceVars,

  # build-system
  hatchling,

  # native dependencies
  xorg,

  # tests
  lsof,
  pillow,
  pytest-cov-stub,
  pytest,
  pyvirtualdisplay,
  xvfb-run,
}:

buildPythonPackage rec {
  pname = "mss";
  version = "10.1.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cYK69+4WylaeKAQCi2q5vL9r5cRvwogIQPM7UTuctPg=";
  };

  patches = lib.optionals stdenv.hostPlatform.isLinux [
    (replaceVars ./linux-paths.patch {
      x11 = "${xorg.libX11}/lib/libX11.so";
      xfixes = "${xorg.libXfixes}/lib/libXfixes.so";
      xrandr = "${xorg.libXrandr}/lib/libXrandr.so";
    })
  ];

  build-system = [ hatchling ];

  doCheck = stdenv.hostPlatform.isLinux;

  nativeCheckInputs = [
    lsof
    pillow
    pytest-cov-stub
    pytest
    pyvirtualdisplay
    xvfb-run
  ];

  checkPhase = ''
    runHook preCheck
    xvfb-run pytest -k "not test_grab_with_tuple and not test_grab_with_tuple_percents and not test_resource_leaks"
    runHook postCheck
  '';

  pythonImportsCheck = [ "mss" ];

  meta = with lib; {
    description = "Cross-platform multiple screenshots module";
    mainProgram = "mss";
    homepage = "https://github.com/BoboTiG/python-mss";
    changelog = "https://github.com/BoboTiG/python-mss/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ austinbutler ];
  };
}
