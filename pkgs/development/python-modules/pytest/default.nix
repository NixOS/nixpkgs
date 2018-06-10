{ stdenv, buildPythonPackage, fetchPypi, isPy26, argparse, attrs, hypothesis, py
, setuptools_scm, setuptools, six, pluggy, funcsigs, isPy3k, more-itertools
}:
buildPythonPackage rec {
  version = "3.5.1";
  pname = "pytest";

  preCheck = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "54713b26c97538db6ff0703a12b19aeaeb60b5e599de542e7fca0ec83b9038e8";
  };

  checkInputs = [ hypothesis ];
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ attrs py setuptools six pluggy more-itertools ]
    ++ (stdenv.lib.optional (!isPy3k) funcsigs)
    ++ (stdenv.lib.optional isPy26 argparse);

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ domenkozar lovek323 madjar lsix ];
    platforms = platforms.unix;
    description = "Framework for writing tests";
  };
}
