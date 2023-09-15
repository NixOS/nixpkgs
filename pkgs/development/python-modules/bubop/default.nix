{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, loguru
, python-dateutil
, pyyaml
, tqdm
}:

buildPythonPackage rec {
  pname = "bubop";
  version = "0.1.10";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "bergercookie";
    repo = "bubop";
    rev = "v${version}";
    hash = "sha256-dr//R3CP/59pr6gMMC4w7x3VfOiml/w8+I2EZYNGWj4=";
  };

  patches = [
    # https://github.com/bergercookie/bubop/pull/4
    ./build-using-poetry-core.patch
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    loguru
    python-dateutil
    pyyaml
    tqdm
  ];

  pythonImportsCheck = [ "bubop" ];

  meta = with lib; {
    description = "Bergercookie's Useful Bits Of Python; helper libraries for Bergercookie's programs";
    homepage = "https://github.com/bergercookie/bubop";
    changelog = "https://github.com/bergercookie/bubop/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
