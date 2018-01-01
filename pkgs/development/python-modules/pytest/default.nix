{ stdenv, buildPythonPackage, fetchPypi, isPy26, argparse, hypothesis, py
, setuptools_scm
}:
buildPythonPackage rec {
  version = "3.2.5";
  pname = "pytest";
  name = "${pname}-${version}";

  preCheck = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "6d5bd4f7113b444c55a3bbb5c738a3dd80d43563d063fc42dcb0aaefbdd78b81";
  };

  buildInputs = [ hypothesis setuptools_scm ];
  propagatedBuildInputs = [ py ]
    ++ (stdenv.lib.optional isPy26 argparse);

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ domenkozar lovek323 madjar lsix ];
    platforms = platforms.unix;
  };
}
