{ stdenv, buildPythonPackage, fetchPypi, isPy26, argparse, attrs, hypothesis, py
, setuptools_scm, setuptools, six, pluggy, funcsigs, isPy3k
}:
buildPythonPackage rec {
  version = "3.3.2";
  pname = "pytest";

  preCheck = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "53548280ede7818f4dc2ad96608b9f08ae2cc2ca3874f2ceb6f97e3583f25bc4";
  };

  checkInputs = [ hypothesis ];
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ attrs py setuptools six pluggy ]
    ++ (stdenv.lib.optional (!isPy3k) funcsigs)
    ++ (stdenv.lib.optional isPy26 argparse);

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ domenkozar lovek323 madjar lsix ];
    platforms = platforms.unix;
    description = "Framework for writing tests";
  };
}
