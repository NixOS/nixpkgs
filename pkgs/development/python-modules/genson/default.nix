{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, unittestCheckHook
, setuptools
, jsonschema
}:

buildPythonPackage rec {
  pname = "genson";
  version = "1.2.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  # The Pypi tarball doesn't contain some test data
  src = fetchFromGitHub {
    owner = "wolverdude";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3RaGY/F//Zt3aOH5ZO+jvRc6vn0+yT14MTYg6yCzO3w=";
  };

  # patches = [ ./fix-test-bin.patch ];
  postPatch = ''
    substituteInPlace test/test_bin.py \
      --replace "BIN_PATH = " "BIN_PATH = \"$out/bin/genson\" # "
  '';

  nativeBuildInputs = [ unittestCheckHook setuptools ];

  propagatedBuildInputs = [ jsonschema ];

  pythonImportsCheck = [ pname ];

  meta = with lib; {
    description = "A powerful, user-friendly JSON Schema generator built in Python";
    homepage = "https://github.com/wolverdude/genson/";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
  };
}
