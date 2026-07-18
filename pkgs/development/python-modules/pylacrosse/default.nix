{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mock,
  pyserial,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pylacrosse";
  version = "0.5";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hthiery";
    repo = "python-lacrosse";
    tag = finalAttrs.version;
    hash = "sha256-z2OlYFFK/+BONg22+Vk0kQQ0KJoQnRkjP7OUS/TVpfI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version = version," "version = '${finalAttrs.version}',"
  '';

  build-system = [ setuptools ];

  dependencies = [ pyserial ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pylacrosse" ];

  meta = {
    description = "Python library for Jeelink LaCrosse";
    mainProgram = "pylacrosse";
    homepage = "https://github.com/hthiery/python-lacrosse";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
})
