{ lib
, pkgs
, buildPythonPackage
, fetchFromGitHub
, pdm-backend
, setuptools
, wheel
, pcre
, pkg-config
, pytestCheckHook
, pytest-mock
}:

buildPythonPackage rec {
  pname = "hyperscan";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darvid";
    repo = "python-hyperscan";
    rev = "v${version}";
    hash = "sha256-6PoV9rY9CkXkAMWN2QCnfU4S0OJD/6bzkqFgvEVqNjo=";
  };

  buildInputs = [
    (pkgs.hyperscan.override { withStatic = true; })
    # we need static pcre to be built, by default only shared library is built
    (pcre.overrideAttrs { dontDisableStatic = 0; })
  ];

  nativeBuildInputs = [
    pkg-config
    pdm-backend
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "hyperscan" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  meta = with lib; {
    description = "A CPython extension for the Hyperscan regular expression matching library";
    homepage = "https://github.com/darvid/python-hyperscan";
    changelog = "https://github.com/darvid/python-hyperscan/blob/${src.rev}/CHANGELOG.md";
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
