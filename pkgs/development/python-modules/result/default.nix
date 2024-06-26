{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-asyncio,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "result";
  version = "0.16.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rustedpy";
    repo = "result";
    rev = "v${version}";
    hash = "sha256-7BvFIQbl4Udd9GTpbMrAqP0P1BGn/C1CHQ3QUCEMXPs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"--flake8",' "" \
      --replace '"--tb=short",' "" \
      --replace '"--cov=result",' "" \
      --replace '"--cov=tests",' "" \
      --replace '"--cov-report=term",' "" \
      --replace '"--cov-report=xml",' ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  passthru.updateScript = nix-update-script { };
  pythonImportsCheck = [ "result" ];

  meta = with lib; {
    description = "A simple Result type for Python 3 inspired by Rust, fully type annotated";
    homepage = "https://github.com/rustedpy/result";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ emattiza ];
  };
}
