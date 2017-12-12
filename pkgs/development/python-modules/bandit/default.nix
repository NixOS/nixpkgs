{ lib, buildPythonPackage, isPy33, isPyPy, fetchPypi, python
, pbr
, six
, pyyaml
, appdirs
, stevedore
, beautifulsoup4
, oslosphinx
, testtools
, testscenarios
, testrepository
, fixtures
, mock
, GitPython
, git
}:
buildPythonPackage rec {
  pname = "bandit";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1m5bm42120zyazky4k0lp3d9r0jwhjmp6sb108xfr0vz952p15yb";
  };

  preCheck = ''
    export PATH=$PATH:$out/bin
  '';

  propagatedBuildInputs = [ pbr six pyyaml appdirs stevedore GitPython git ];
  checkInputs = [ beautifulsoup4 oslosphinx testtools testscenarios
                              testrepository fixtures mock ];
  postPatch = ''
    sed -i 's@python@${python.interpreter}@' .testr.conf
  '';
  meta = with lib;{
    homepage = https://github.com/openstack/bandit;
    description = "Python AST-based static analyzer from OpenStack Security Group";
    license = licenses.asl20;
  };
}
