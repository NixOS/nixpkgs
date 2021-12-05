{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook, pythonOlder }:

buildPythonPackage rec {
  pname = "awesomeversion";
  version = "21.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = version;
    sha256 = "sha256-qxN5AdLlzadG0/raeAyJ/37PLgYLndl1JQSVkgdLv/4=";
  };

  postPatch = ''
    # Upstream doesn't set a version
    substituteInPlace setup.py \
      --replace "main" ${version}
  '';

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "awesomeversion" ];

  meta = with lib; {
    description = "Python module to deal with versions";
    homepage = "https://github.com/ludeeus/awesomeversion";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
