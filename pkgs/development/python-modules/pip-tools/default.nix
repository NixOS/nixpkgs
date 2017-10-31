{ stdenv, fetchurl, buildPythonPackage, pip, pytest, click, six, first
, setuptools_scm, glibcLocales, mock }:

buildPythonPackage rec {
  pname = "pip-tools";
  version = "1.10.1";
  name = "pip-tools-${version}";

  src = fetchurl {
    url = "mirror://pypi/p/pip-tools/${name}.tar.gz";
    sha256 = "37b85d69ceed97337aeefb3e52e41fe0884a505c874757a5bbaa58d92b533ce0";
  };

  LC_ALL = "en_US.UTF-8";
  checkInputs = [ pytest glibcLocales mock ];
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
