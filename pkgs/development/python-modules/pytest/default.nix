{ stdenv, buildPythonPackage, fetchPypi, isPy26, argparse, hypothesis, py
, setuptools_scm
}:
buildPythonPackage rec {
  version = "3.2.1";
  pname = "pytest";
  name = "${pname}-${version}";

  preCheck = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c2159d2be2b4e13fa293e7a72bdf2f06848a017150d5c6d35112ce51cfd74ce";
  };

  buildInputs = [ hypothesis setuptools_scm ];
  propagatedBuildInputs = [ py ]
    ++ (stdenv.lib.optional isPy26 argparse);

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ domenkozar lovek323 madjar lsix ];
    platforms = platforms.unix;
  };
}
