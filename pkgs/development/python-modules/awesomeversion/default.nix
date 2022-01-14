{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "awesomeversion";
  version = "22.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = version;
    sha256 = "1z9b7bxd5spp2yvjka3ay44crrpgs7xk6x4ppnkhp6iw8zdkv1ks";
  };

  postPatch = ''
    # Upstream doesn't set a version
    substituteInPlace setup.py \
      --replace "main" ${version}
  '';

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "awesomeversion"
  ];

  meta = with lib; {
    description = "Python module to deal with versions";
    homepage = "https://github.com/ludeeus/awesomeversion";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
