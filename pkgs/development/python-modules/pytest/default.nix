{ stdenv, buildPythonPackage, fetchPypi, isPy26, argparse, hypothesis, py
, setuptools_scm, setuptools
}:
buildPythonPackage rec {
  version = "3.2.3";
  pname = "pytest";

  preCheck = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "27fa6617efc2869d3e969a3e75ec060375bfb28831ade8b5cdd68da3a741dc3c";
  };

  checkInputs = [ hypothesis ];
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ py setuptools ]
    ++ (stdenv.lib.optional isPy26 argparse);

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ domenkozar lovek323 madjar lsix ];
    platforms = platforms.unix;
  };
}
