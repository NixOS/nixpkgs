{ lib, buildPythonPackage, fetchFromGitHub, fetchpatch
, execnet
, glob2
, Mako
, mock
, parse
, parse-type
, py
, pytest
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "pytest-bdd";
  version = "4.0.2";

  # tests are not included in pypi tarball
  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = pname;
    rev = version;
    sha256 = "0pxx4c8lm68rw0jshbr09fnadg8zz8j73q0qi49yw9s7yw86bg5l";
  };

  patches = [
    # Fixed compatibility with pytest > 6.1
    (fetchpatch {
      url = "https://github.com/pytest-dev/pytest-bdd/commit/e1dc0cad9a1c1ba563ccfbc24f9993d83ac59293.patch";
      sha256 = "1p3gavh6nir2a8crd5wdf0prfrg0hmgar9slvn8a21ils3k5pm5y";
    })
  ];


  buildInputs = [ pytest ];

  propagatedBuildInputs = [ glob2 Mako parse parse-type py six ];

  checkInputs = [ pytestCheckHook execnet mock ];
  preCheck = ''
    export PATH=$PATH:$out/bin
  '';

  meta = with lib; {
    description = "BDD library for the py.test runner";
    homepage = "https://github.com/pytest-dev/pytest-bdd";
    license = licenses.mit;
    maintainers = with maintainers; [ jm2dev ];
  };
}
