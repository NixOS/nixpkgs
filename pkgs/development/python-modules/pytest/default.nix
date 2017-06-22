{ stdenv, buildPythonPackage, fetchurl, isPy26, argparse, hypothesis, py }:
buildPythonPackage rec {
  version = "3.0.7";
  pname = "pytest";
  name = "${pname}-${version}";

  preCheck = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  src = fetchurl {
    url = "mirror://pypi/p/pytest/${name}.tar.gz";
    sha256 = "b70696ebd1a5e6b627e7e3ac1365a4bc60aaf3495e843c1e70448966c5224cab";
  };

  buildInputs = [ hypothesis ];
  propagatedBuildInputs = [ py ]
    ++ (stdenv.lib.optional isPy26 argparse);

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ domenkozar lovek323 madjar lsix ];
    platforms = platforms.unix;
  };
}
