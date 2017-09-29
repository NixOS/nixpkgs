{ stdenv, fetchurl, buildPythonPackage, pip, pytest, click, six, first, setuptools_scm, glibcLocales }:
buildPythonPackage rec {
  pname = "pip-tools";
  version = "1.9.0";
  name = "pip-tools-${version}";

  src = fetchurl {
    url = "mirror://pypi/p/pip-tools/${name}.tar.gz";
    sha256 = "0mjdpq2zjn8n4lzn9l2myh4bv0l2f6751k1rdpgdm8k3fargw1h7";
  };

  LC_ALL = "en_US.UTF-8";
  buildInputs = [ pytest glibcLocales ];
  propagatedBuildInputs = [ pip click six first setuptools_scm ];

  checkPhase = ''
    export HOME=$(mktemp -d)
    py.test -k "not test_realistic_complex_sub_dependencies" # requires network
  '';

  meta = with stdenv.lib; {
    description = "Keeps your pinned dependencies fresh";
    homepage = https://github.com/jazzband/pip-tools/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ zimbatm ];
  };
}
