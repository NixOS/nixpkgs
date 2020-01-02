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
    sha256 = "0jj1vjmwgaj6d3f3xslcfq5zp16z7rxwlahfp36661fpha35v4pb";
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
  };
}
