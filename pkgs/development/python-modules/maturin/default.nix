{ buildPythonPackage
, maturin
, setuptools
, toml
, wheel
, isPy3k
}:

buildPythonPackage {
  inherit (maturin) pname version src meta;

  format = "pyproject";

  nativeBuildInputs = [
    setuptools
    toml
    wheel
  ];

  propagatedBuildInputs = [
    maturin.rustPlatform.rust.cargo
    maturin.rustPlatform.rust.rustc
  ];

  disabled = !isPy3k;

  patches = [
    ./0001-Don-t-build-maturin-executable.patch
    ./0002-declare-maturin-executable.patch
    ./0003-install-python-module.patch
  ];

  maturin = "${maturin}/bin/maturin";

  postPatch = ''
    substituteAllInPlace maturin/__init__.py
  '';

  # No tests
  doCheck = false;
}