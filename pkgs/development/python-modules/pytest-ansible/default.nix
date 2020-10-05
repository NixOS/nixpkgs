{ stdenv
, buildPythonPackage
, fetchFromGitHub
, ansible
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "pytest-ansible";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "ansible";
    repo = "pytest-ansible";
    rev = "v${version}";
    sha256 = "147rbhadgrf8bn430cc8swkgp3jybagrncrn53hzf44x19xiqpx9";
  };

  patchPhase = ''
    sed -i "s/'setuptools-markdown'//g" setup.py
  '';

  # requires pandoc < 2.0
  # buildInputs = [ setuptools-markdown ];
  checkInputs =  [ mock ];
  propagatedBuildInputs = [ ansible pytest ];

  # tests not included with release, even on github
  doCheck = false;

  checkPhase = ''
    HOME=$TMPDIR pytest tests/
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/jlaska/pytest-ansible";
    description = "Plugin for py.test to simplify calling ansible modules from tests or fixtures";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
