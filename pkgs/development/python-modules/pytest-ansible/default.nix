{ stdenv
, buildPythonPackage
, fetchPypi
, ansible
, pytest
, mock
, isPy3k
}:

buildPythonPackage rec {
  version = "2.0.1";
  pname = "pytest-ansible";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "553f2bc9e64f8c871ad29b7d5c100f6e549fe85db26bd1ff5dda8b769bb38a3e";
  };

  patchPhase = ''
    sed -i "s/'setuptools-markdown'//g" setup.py
  '';

  # requires pandoc < 2.0
  # buildInputs = [ setuptools-markdown ];
  checkInputs =  [ mock ];
  propagatedBuildInputs = [ ansible pytest ];

  # tests not included with release
  doCheck = false;

  checkPhase = ''
    pytest tests
  '';

  meta = with stdenv.lib; {
    homepage = http://github.com/jlaska/pytest-ansible;
    description = "Plugin for py.test to simplify calling ansible modules from tests or fixtures";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
