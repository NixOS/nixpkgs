{ lib
, angr
, buildPythonPackage
, cmd2
, coreutils
, fetchFromGitHub
, pygments
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "angrcli";
  version = "1.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "fmagin";
    repo = "angr-cli";
    rev = "v${version}";
    sha256 = "0mz3yzsw08xwpj6188rxmr7darilh4ismcnh8nhp9945wjyzl4kr";
  };

  propagatedBuildInputs = [
    angr
    cmd2
    pygments
  ];

  checkInputs = [
    coreutils
    pytestCheckHook
  ];

  postPatch = ''
    # Version mismatch, https://github.com/fmagin/angr-cli/pull/11
    substituteInPlace setup.py \
      --replace "version='1.1.0'," "version='${version}',"
    substituteInPlace tests/test_derefs.py \
      --replace "/bin/ls" "${coreutils}/bin/ls"
  '';

  disabledTests = [
    "test_sims"
  ];

  pythonImportsCheck = [
    "angrcli"
  ];

  meta = with lib; {
    description = "Python modules to allow easier interactive use of angr";
    homepage = "https://github.com/fmagin/angr-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
