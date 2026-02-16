{
  buildPythonPackage,
  django,
  fetchFromGitHub,
  lib,
  nix-update-script,
  setuptools,
  user-agents,
}:

buildPythonPackage rec {
  pname = "django-user_agents";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "selwin";
    repo = "django-user_agents";
    tag = "v${version}";
    hash = "sha256-xn0PaS/OTgQaj8fry/xnEMX151nJTs6StkeNc3Qfg0k=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    user-agents
  ];

  prePatch = ''substituteInPlace django_user_agents/tests/urls.py --replace-fail "from django.conf.urls import url" "from django.urls import re_path as url"'';

  checkPhase = ''
    runHook preCheck

    python -Wd manage.py test

    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A django package that allows easy identification of visitor's browser";
    homepage = "https://github.com/selwin/django-user_agents";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mrtipson ];
  };
}
