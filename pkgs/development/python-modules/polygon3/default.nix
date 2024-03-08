{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage {
  pname = "polygon3";
  version = "3.0.9";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jraedler";
    repo = "Polygon3";
    rev = "7b2091f77741fa1d94251979bc4a4f2676b4d2d1";
    hash = "sha256-jXtjEzjWwMoVgrHWsK8brSN6TQRxIPRjUaRiLBXYLcI=";
  };

  # malloc error on running the tests
  #  python3.10(30620,0x115b74600) malloc: *** error for object 0x10d6db580: pointer being freed was not allocated
  # > python3.10(30620,0x115b74600) malloc: *** set a breakpoint in malloc_error_break to debug
  # > /nix/store/vbi8rnz0k3jyh4h4g16bbkchdd8mnxw7-setuptools-check-hook/nix-support/setup-hook: line 4: 30620 Abort trap: 6           /nix/store/5cxanhipcbfxnrqgw2qsr3zqr4z711bj-python3-3.10.12/bin/python3.10 nix_run_setup test
  doCheck = false;

  meta = with lib; {
    description = "Polygon is a python package that handles polygonal shapes in 2D";
    homepage = "https://github.com/jraedler/Polygon3";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
