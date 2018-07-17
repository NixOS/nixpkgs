{ stdenv, buildPythonPackage, fetchPypi, attrs, hypothesis, py
, setuptools_scm, setuptools, six, pluggy, funcsigs, isPy3k, more-itertools
, atomicwrites, mock
}:
buildPythonPackage rec {
  version = "3.6.2";
  pname = "pytest";

  preCheck = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ea01fc4fcc8e1b1e305252b4bc80a1528019ab99fd3b88666c9dc38d754406c";
  };

  checkInputs = [ hypothesis mock ];
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ attrs py setuptools six pluggy more-itertools atomicwrites]
    ++ (stdenv.lib.optional (!isPy3k) funcsigs);

  checkPhase = ''
    runHook preCheck
    $out/bin/py.test -x testing/
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ domenkozar lovek323 madjar lsix ];
    platforms = platforms.unix;
    description = "Framework for writing tests";
  };
}
