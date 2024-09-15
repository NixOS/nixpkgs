{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  future,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nampa";
  version = "1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "thebabush";
    repo = "nampa";
    rev = "refs/tags/${version}";
    hash = "sha256-ylDthh6fO0jKiYib0bed31Dxt4afiD0Jd5mfRKrsZpE=";
  };

  postPatch = ''
    # https://github.com/thebabush/nampa/pull/13
    substituteInPlace setup.py \
      --replace "0.1.1" "${version}"
  '';

  build-system = [ setuptools ];

  dependencies = [ future ];

  # Not used for binaryninja as plugin
  doCheck = false;

  pythonImportsCheck = [ "nampa" ];

  meta = with lib; {
    description = "Python implementation of the FLIRT technology";
    homepage = "https://github.com/thebabush/nampa";
    changelog = "https://github.com/thebabush/nampa/releases/tag/${version}";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
