{ stdenv
, buildPythonPackage
, fetchPypi
, ansible
, pytest
, mock
, isPy3k
}:

buildPythonPackage rec {
  pname = "pytest-ansible";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d69d89cbcf29e587cbe6ec4b229346edbf027d3c04944dd7bcbf3d7bba46348f";
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
    pytest
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/jlaska/pytest-ansible;
    description = "Plugin for py.test to simplify calling ansible modules from tests or fixtures";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
