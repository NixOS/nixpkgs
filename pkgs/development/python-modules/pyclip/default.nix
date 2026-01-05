{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  pytest,
  pythonOlder,
  xclip,
  xvfb-run,
}:

buildPythonPackage rec {
  pname = "pyclip";
  version = "0.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "spyoungtech";
    repo = "pyclip";
    tag = "v${version}";
    hash = "sha256-0nOkNgT8XCwtXI9JZntkhoMspKQU602rTKBFajVKBoM=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace docs/README.md README.md
  '';

  nativeCheckInputs = [
    pytest
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    xclip
    xvfb-run
  ];

  checkPhase = ''
    runHook preCheck
    ${lib.optionalString stdenv.hostPlatform.isLinux "xvfb-run -s '-screen 0 800x600x24'"} pytest tests
    runHook postCheck
  '';

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Cross-platform clipboard utilities supporting both binary and text data";
    mainProgram = "pyclip";
    homepage = "https://github.com/spyoungtech/pyclip";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
