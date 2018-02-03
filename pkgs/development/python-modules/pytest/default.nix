{ stdenv, buildPythonPackage, fetchPypi, isPy26, argparse, attrs, hypothesis, py
, setuptools_scm, setuptools, six, pluggy, funcsigs, isPy3k
}:
buildPythonPackage rec {
  version = "3.4.0";
  pname = "pytest";

  preCheck = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "6074ea3b9c999bd6d0df5fa9d12dd95ccd23550df2a582f5f5b848331d2e82ca";
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
