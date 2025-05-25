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
    rev = "v${version}_as_released";
    sha256 = "sha256-T8hzC9ulikQ1pUdbXgjuKAX5oMJEycPvXWv74rCkQGY=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "low_index" ];

  meta = with lib; {
    description = "Enumerates low index subgroups of a finitely presented group";
    homepage = "https://github.com/3-manifolds/low_index";
    license = licenses.gpl2;
    maintainers = with maintainers; [ noiioiu ];
  };
}
