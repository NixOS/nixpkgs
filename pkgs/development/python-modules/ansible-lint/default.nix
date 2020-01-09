{ lib
, fetchPypi
, buildPythonPackage
, ansible
, pyyaml
, six
, nose
, setuptools_scm
, ruamel_yaml
}:

buildPythonPackage rec {
  pname = "ansible-lint";
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb925d8682d70563ccb80e2aca7b3edf84fb0b768cea3edc6846aac7abdc414a";
  };

  format = "pyproject";

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ pyyaml six ansible ruamel_yaml ];
  checkInputs = [ nose ];

  postPatch = ''
    patchShebangs bin/ansible-lint
    substituteInPlace setup.cfg \
      --replace "setuptools_scm_git_archive>=1.0" ""
  '';

  # give a hint to setuptools_scm on package version
  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="v${version}"
    export HOME=$(mktemp -d)
  '';

  checkPhase = ''
    PATH=$out/bin:$PATH nosetests test
  '';

  meta = with lib; {
    homepage = "https://github.com/willthames/ansible-lint";
    description = "Best practices checker for Ansible";
    license = licenses.mit;
    maintainers = [ maintainers.sengaya ];
    broken = true; # requires new flit to build
  };
}
