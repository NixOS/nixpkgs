{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pynose,
  pyserial,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pylacrosse";
  version = "0.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hthiery";
    repo = "python-lacrosse";
    rev = "refs/tags/${version}";
    hash = "sha256-jrkehoPLYbutDfxMBO/vlx4nMylTNs/gtvoBTFHFsDw=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version = version," "version = '${version}',"
  '';

  propagatedBuildInputs = [ pyserial ];

  nativeCheckInputs = [
    mock
    pynose
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pylacrosse" ];

  meta = with lib; {
    description = "Python library for Jeelink LaCrosse";
    mainProgram = "pylacrosse";
    homepage = "https://github.com/hthiery/python-lacrosse";
    license = with licenses; [ lgpl2Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
