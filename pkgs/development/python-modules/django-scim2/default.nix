{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  poetry-core,

  # propagates
  django,
  scim2-filter-parser,

  # tests
  mock,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-scim2";
  version = "0.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "15five";
    repo = "django-scim2";
    tag = version;
    hash = "sha256-8zPUlvVHVowzPU+sfQGoOrJ+Vdm8zVKI5V+wTJnIBZ0=";
  };

  patches = [
    # These two patches update dependencies & the min. python version.
    # They're applied such that the third can be applied trivially.
    (fetchpatch {
      url = "https://github.com/15five/django-scim2/commit/df3bd25d477928ceecdd02410babf9b59e67c595.patch";
      hash = "sha256-BkBBbxImCKfSBDY7hTmKX6z/+l7H2MRmIJ4VHKxFtnM=";
    })
    (fetchpatch {
      url = "https://github.com/15five/django-scim2/commit/be4e67f158b50fd216d723024d975d8b15f4031a.patch";
      hash = "sha256-IE8yg7qdv5UWla5T1erAM3KK7TAb3qYBqjNJdV4+8C0=";
    })
    # Python 3.14 compat
    # Includes support for newer Django.
    (fetchpatch {
      url = "https://github.com/15five/django-scim2/commit/131ec58a94c66f2f1b205a96e9405c76828de7db.patch";
      hash = "sha256-KafF2I6CFCVz96NVHBoGmJLB6ejdLJaWBx2F0EoEwrI=";
    })
  ];

  build-system = [ poetry-core ];

  dependencies = [
    django
    scim2-filter-parser
  ];

  pythonImportsCheck = [ "django_scim" ];

  nativeCheckInputs = [
    mock
    pytest-django
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/15five/django-scim2/blob/${src.tag}/CHANGES.txt";
    description = "SCIM 2.0 Service Provider Implementation (for Django)";
    homepage = "https://github.com/15five/django-scim2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ s1341 ];
  };
}
