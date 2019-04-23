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
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9430ea6e654ba4bf5b9c6921efc040f46cda9c4fd2896a99ff71d21037bcb123";
  };

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
  '';

  checkPhase = ''
    PATH=$out/bin:$PATH HOME=$(mktemp -d) nosetests test
  '';

  meta = with lib; {
    homepage = "https://github.com/willthames/ansible-lint";
    description = "Best practices checker for Ansible";
    license = licenses.mit;
    maintainers = [ maintainers.sengaya ];
  };
}
