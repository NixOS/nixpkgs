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
  version = "4.1.1a0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00mw56a3lmdb5xvrzhahrzqv3wvxfz0mxl4n0qbkxzggf2pg0i8d";
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
