{ stdenv, buildPythonPackage, fetchPypi, isPy26, argparse, hypothesis, py, setuptools_scm }:
buildPythonPackage rec {
  version = "3.1.3";
  pname = "pytest";
  name = "${pname}-${version}";

  preCheck = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "01k2abl6x60ac7wx5k9rw602n1b5r39xix6sjly5c974ywr1hph9";
  };

  buildInputs = [ hypothesis setuptools_scm ];
  propagatedBuildInputs = [ py ]
    ++ (stdenv.lib.optional isPy26 argparse);

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ domenkozar lovek323 madjar lsix ];
    platforms = platforms.unix;
  };
}
