{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  flit-core,
  psycopg2,
  pydantic,
  pytest-asyncio,
  pytest-django,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "django-ninja";
<<<<<<< HEAD
  version = "1.4.5";
=======
  version = "1.4.3t";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vitalik";
    repo = "django-ninja";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-C54Y5Rmhk9trEeNhE+i3aeKcnoeUc6BqFbp3dzL9xjA=";
=======
    hash = "sha256-IiOj2fBuClHyIdn/r3XxKwO+DyrgahagUKrxp+YKZ4E=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ flit-core ];

  dependencies = [
    django
    pydantic
  ];

  nativeCheckInputs = [
    psycopg2
    pytest-asyncio
    pytest-django
    pytestCheckHook
  ];

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/vitalik/django-ninja/releases/tag/${src.tag}";
    description = "Web framework for building APIs with Django and Python type hints";
    homepage = "https://django-ninja.dev";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    changelog = "https://github.com/vitalik/django-ninja/releases/tag/${src.tag}";
    description = "Web framework for building APIs with Django and Python type hints";
    homepage = "https://django-ninja.dev";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
