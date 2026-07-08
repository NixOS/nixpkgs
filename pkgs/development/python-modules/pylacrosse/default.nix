{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pyserial,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pylacrosse";
  version = "0.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "hthiery";
    repo = "python-lacrosse";
    tag = version;
    hash = "sha256-z2OlYFFK/+BONg22+Vk0kQQ0KJoQnRkjP7OUS/TVpfI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version = version," "version = '${version}',"
  '';

  propagatedBuildInputs = [ pyserial ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pylacrosse" ];

  meta = {
    description = "Python library for Jeelink LaCrosse";
    mainProgram = "pylacrosse";
    homepage = "https://github.com/hthiery/python-lacrosse";
    license = with lib.licenses; [ lgpl2Plus ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
