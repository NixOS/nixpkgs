{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "low-index";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "low_index";
    tag = "v${version}_as_released";
    hash = "sha256-T8hzC9ulikQ1pUdbXgjuKAX5oMJEycPvXWv74rCkQGY=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "low_index" ];

  meta = {
    description = "Enumerates low index subgroups of a finitely presented group";
    changelog = "https://github.com/3-manifolds/low_index/releases/tag/${src.tag}";
    homepage = "https://github.com/3-manifolds/low_index";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ noiioiu ];
  };
}
