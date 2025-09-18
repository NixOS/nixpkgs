{
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "libpyfoscamcgi";
  version = "0.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Foscam-wangzhengyu";
    repo = "libfoscamcgi";
    tag = "v${version}";
    hash = "sha256-QthzyMdZ2iberDmbeqf6MaUv8lH5xhlZLL8ZAlapvIk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    defusedxml
  ];

  pythonImportsCheck = [ "libpyfoscamcgi" ];

  # tests need access to a camera
  doCheck = false;

  meta = {
    changelog = "https://github.com/Foscam-wangzhengyu/libfoscamcgi/releases/tag/${src.tag}";
    description = "Python Library for Foscam IP Cameras";
    homepage = "https://github.com/Foscam-wangzhengyu/libfoscamcgi";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
