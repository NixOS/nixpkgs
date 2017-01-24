{ stdenv, buildPythonPackage, fetchurl, hypothesis, py }:
buildPythonPackage rec {
  name = "pytest-${version}";
  version = "3.0.5";

  preCheck = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  src = fetchurl {
    url = "mirror://pypi/p/pytest/${name}.tar.gz";
    sha256 = "1z9pj39w0r2gw5hsqndlmsqa80kgbrann5kfma8ww8zhaslkl02a";
  };

  propagatedBuildInputs = [ hypothesis py ];

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ domenkozar lovek323 madjar ];
    platforms = platforms.unix;
  };
}
