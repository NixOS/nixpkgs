{ lib, stdenv, fetchFromGitHub, buildPythonPackage, typed-ast, psutil, isPy3k
, mypy-extensions
, typing-extensions
, fetchpatch
}:
buildPythonPackage rec {
  pname = "mypy";
  version = "0.790";
  disabled = !isPy3k;

  # Fetch 0.790 from GitHub temporarily because mypyc.analysis is missing from
  # the Pip package (see also https://github.com/python/mypy/issues/9584). It
  # should be possible to move back to Pypi for the next release.
  src = fetchFromGitHub {
    owner = "python";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zq3lpdf9hphcklk40wz444h8w3dkhwa12mqba5j9lmg11klnhz7";
    fetchSubmodules = true;
  };

  propagatedBuildInputs = [ typed-ast psutil mypy-extensions typing-extensions ];

  # Tests not included in pip package.
  doCheck = false;

  pythonImportsCheck = [
    "mypy"
    "mypy.types"
    "mypy.api"
    "mypy.fastparse"
    "mypy.report"
    "mypyc"
    "mypyc.analysis"
  ];

  # These three patches are required to make compilation with mypyc work for
  # 0.790, see also https://github.com/python/mypy/issues/9584.
  patches = [
    (fetchpatch {
      url = "https://github.com/python/mypy/commit/f6522ae646a8d87ce10549f29fcf961dc014f154.patch";
      sha256 = "0d3jp4d0b7vdc0prk07grhajsy7x3wcynn2xysnszawiww93bfrh";
    })
    (fetchpatch {
      url = "https://github.com/python/mypy/commit/acd603496237a78b109ca9d89991539633cbbb99.patch";
      sha256 = "0ry1rxpz2ws7zzrmq09pra9dlzxb84zhs8kxwf5xii1k1bgmrljr";
    })
    (fetchpatch {
      url = "https://github.com/python/mypy/commit/81818b23b5d53f31caf3515d6f0b54e3c018d790.patch";
      sha256 = "002y24kfscywkw4mz9lndsps543j4xhr2kcnfbrqr4i0yxlvdbca";
    })
  ];

  # Compile mypy with mypyc, which makes mypy about 4 times faster. The compiled
  # version is also the default in the wheels on Pypi that include binaries.
  # is64bit: unfortunately the build would exhaust all possible memory on i686-linux.
  MYPY_USE_MYPYC = stdenv.buildPlatform.is64bit;

  meta = with lib; {
    description = "Optional static typing for Python";
    homepage    = "http://www.mypy-lang.org";
    license     = licenses.mit;
    maintainers = with maintainers; [ martingms lnl7 ];
  };
}
