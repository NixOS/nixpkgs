{ lib
, buildPythonPackage
, fetchFromGitHub
, ansible
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "pytest-ansible";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "ansible";
    repo = "pytest-ansible";
    rev = "v${version}";
    sha256 = "0vh2f34qxs8qfv15hf1q7li2iqjiydjsb4c86i2ma1b7vhi73j57";
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
  };
}
