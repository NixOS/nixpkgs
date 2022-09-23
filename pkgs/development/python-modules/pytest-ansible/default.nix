{ lib
, buildPythonPackage
, fetchFromGitHub
, ansible
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "pytest-ansible";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "ansible";
    repo = "pytest-ansible";
    rev = "v${version}";
    sha256 = "0vr015msciwzz20zplxalfmfx5hbg8rkf8vwjdg3z12fba8z8ks4";
  };

  patchPhase = ''
    sed -i "s/'setuptools-markdown'//g" setup.py
  '';

  buildInputs = [ pytest ];

  # requires pandoc < 2.0
  # buildInputs = [ setuptools-markdown ];
  checkInputs =  [ mock ];
  propagatedBuildInputs = [ ansible ];

  # tests not included with release, even on github
  doCheck = false;

  checkPhase = ''
    HOME=$TMPDIR pytest tests/
  '';

  meta = with lib; {
    homepage = "https://github.com/jlaska/pytest-ansible";
    description = "Plugin for py.test to simplify calling ansible modules from tests or fixtures";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
    # https://github.com/ansible-community/pytest-ansible/blob/v2.2.4/setup.py#L124
    broken = lib.versionAtLeast ansible.version "2.10";
  };
}
