{ lib, buildPythonPackage, fetchgit, poetry-core, pytestCheckHook, pytest-benchmark, pytest-mypy, pillow }:

buildPythonPackage rec {
  pname = "pixelmatch";
  version = "0.2.2";
  format = "pyproject";

  # test fixtures are stored in LFS
  src = fetchgit {
    url = "https://github.com/whtsky/pixelmatch-py";
    rev = "v${version}";
    sha256 = "1dsix507dxqik9wvgzscvf2pifbg7gx74krrsalqbfcmm7d1i7xl";
    fetchLFS = true;
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    pytestCheckHook
    pytest-benchmark
    pytest-mypy
    pillow
  ];

  pytestFlagsArray = [
    "--mypy"
    "--benchmark-disable"
  ];

  meta = with lib; {
    description = "A pixel-level image comparison library.";
    homepage = "https://github.com/whtsky/pixelmatch-py";
    license = licenses.isc;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
