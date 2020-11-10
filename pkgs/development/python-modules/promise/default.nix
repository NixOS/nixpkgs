{ buildPythonPackage
, fetchPypi
, lib

, coveralls
, gevent
, mock
, pytest-asyncio
, pytest-benchmark
, pytestcov
, six
}:

buildPythonPackage rec {
  pname = "promise";
  version = "2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1l4kknj97dj5pxfpsz3ln78x9a843561c740b1m4pfi3qlvq7lfz";
  };

  patchPhase = ''
    substituteInPlace setup.py \
      --replace '"futures",' ""
  '';

  propagatedBuildInputs = [
    gevent
    six
  ];

  checkInputs = [
    coveralls
    mock
    pytest-asyncio
    pytest-benchmark
    pytestcov
  ];

  meta = with lib; {
    description = "Ultra-performant Promise implementation in Python";
    homepage = "https://github.com/syrusakbary/promise";
    license = licenses.mit;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
