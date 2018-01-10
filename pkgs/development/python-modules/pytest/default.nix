{ stdenv, buildPythonPackage, fetchPypi, isPy26, argparse, attrs, hypothesis, py
, setuptools_scm, setuptools, six, pluggy, funcsigs, isPy3k
}:
buildPythonPackage rec {
  version = "3.3.1";
  pname = "pytest";

  preCheck = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf8436dc59d8695346fcd3ab296de46425ecab00d64096cebe79fb51ecb2eb93";
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
