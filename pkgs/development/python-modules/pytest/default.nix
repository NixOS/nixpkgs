{ stdenv, buildPythonPackage, fetchurl, isPy26, argparse, hypothesis, py }:
buildPythonPackage rec {
  name = "pytest-${version}";
  version = "3.0.6";

  preCheck = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  src = fetchurl {
    url = "mirror://pypi/p/pytest/${name}.tar.gz";
    sha256 = "0h6rfp7y7c5mqwfm9fy5fq4l9idnp160c82ylcfjg251y6lk8d34";
  };

  buildInputs = [ hypothesis ];
  propagatedBuildInputs = [ py ]
    ++ (stdenv.lib.optional isPy26 argparse);

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ domenkozar lovek323 madjar lsix ];
    platforms = platforms.unix;
  };
}
