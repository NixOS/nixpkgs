{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, pytest
, pythonOlder
, xclip
, xvfb-run
}:

buildPythonPackage rec {
  pname = "pyclip";
  version = "0.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "spyoungtech";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-0nOkNgT8XCwtXI9JZntkhoMspKQU602rTKBFajVKBoM=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace docs/README.md README.md
  '';

  checkInputs = [
    pytest
  ] ++ lib.optionals stdenv.isLinux [
    xclip
    xvfb-run
  ];

  checkPhase = ''
    runHook preCheck
    ${lib.optionalString stdenv.isLinux "xvfb-run -s '-screen 0 800x600x24'"} pytest tests
    runHook postCheck
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Cross-platform clipboard utilities supporting both binary and text data";
    homepage = "https://github.com/spyoungtech/pyclip";
    license = licenses.asl20;
    maintainers = with maintainers; [ mcaju ];
  };
}
