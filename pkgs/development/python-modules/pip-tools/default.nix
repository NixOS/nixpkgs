{ stdenv, fetchurl, buildPythonPackage, pip, pytest, click, six, first
, setuptools_scm, git, glibcLocales, mock }:

buildPythonPackage rec {
  pname = "pip-tools";
  version = "1.10.1";
  name = "pip-tools-${version}";

  src = fetchurl {
    url = "mirror://pypi/p/pip-tools/${name}.tar.gz";
    sha256 = "37b85d69ceed97337aeefb3e52e41fe0884a505c874757a5bbaa58d92b533ce0";
  };

  LC_ALL = "en_US.UTF-8";
  checkInputs = [ pytest git glibcLocales mock ];
  propagatedBuildInputs = [ pip click six first setuptools_scm ];

  checkPhase = ''
    export HOME=$(mktemp -d) VIRTUAL_ENV=1
    tests_without_network_access="
      not test_realistic_complex_sub_dependencies \
      and not test_editable_package_vcs \
      and not test_generate_hashes_all_platforms \
      and not test_generate_hashes_without_interfering_with_each_other \
    "
    py.test -k "$tests_without_network_access"
  '';

  meta = with stdenv.lib; {
    description = "Keeps your pinned dependencies fresh";
    homepage = https://github.com/jazzband/pip-tools/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ zimbatm ];
  };
}
