{ lib
, buildPythonPackage
, fetchFromGitHub

<<<<<<< HEAD
# build-system
, poetry-core

# propagates
, django
, scim2-filter-parser

# tests
, mock
, pytest-django
, pytestCheckHook
=======
# propagates
, django
, python-dateutil
, scim2-filter-parser
, gssapi
, python-ldap
, sssd

# tests
, mock
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "django-scim2";
<<<<<<< HEAD
  version = "0.19.0";
  format = "pyproject";
=======
  version = "0.17.3";
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "15five";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-larDh4f9/xVr11/n/WfkJ2Tx45DMQqyK3ZzkWAvzeig=";
  };

  # remove this when upstream releases a new version > 0.19.0
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry>=0.12" "poetry-core>=1.5.2" \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    django
    scim2-filter-parser
=======
    hash = "sha256-5zdGPpjooiFoj+2OoglXhhKsPFB/KOHvrZWZd+1nZqU=";
  };

  propagatedBuildInputs = [
    django
    python-dateutil
    scim2-filter-parser
    gssapi
    python-ldap
    sssd
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "django_scim"
  ];

  nativeCheckInputs = [
    mock
<<<<<<< HEAD
    pytest-django
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/15five/django-scim2/blob/${src.rev}/CHANGES.txt";
=======
  ];

  meta = with lib; {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "A SCIM 2.0 Service Provider Implementation (for Django)";
    homepage = "https://github.com/15five/django-scim2";
    license = licenses.mit;
    maintainers = with maintainers; [ s1341 ];
  };
}
