{
  lib,
  beautifulsoup4,
  bleach,
  buildPythonPackage,
  chardet,
  django,
  django-contrib-comments,
  fetchFromGitHub,
  filebrowser-safe,
  grappelli-safe,
  isPyPy,
  pillow,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-django,
  pythonOlder,
  pytz,
  requests,
  requests-oauthlib,
  requirements-parser,
  setuptools,
  tzlocal,
}:

buildPythonPackage rec {
  pname = "mezzanine";
  version = "6.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7" || isPyPy;

  src = fetchFromGitHub {
    owner = "stephenmcd";
    repo = "mezzanine";
    tag = "v${version}";
    hash = "sha256-TdGWlquS4hsnxIM0bhbWR7C0X4wyUcqC+YrBDSShRhg=";
  };

  patches = [
    # drop git requirement from tests and fake stable branch
    ./tests-no-git.patch
  ];

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    bleach
    chardet
    django
    django-contrib-comments
    filebrowser-safe
    grappelli-safe
    pillow
    pytz
    requests
    requests-oauthlib
    tzlocal
  ]
  ++ bleach.optional-dependencies.css;

  nativeCheckInputs = [
    pytest-django
    pytest-cov-stub
    pytestCheckHook
    requirements-parser
  ];

  meta = with lib; {
    description = "Content management platform built using the Django framework";
    mainProgram = "mezzanine-project";
    longDescription = ''
      Mezzanine is a powerful, consistent, and flexible content
      management platform. Built using the Django framework, Mezzanine
      provides a simple yet highly extensible architecture that
      encourages diving in and hacking on the code. Mezzanine is BSD
      licensed and supported by a diverse and active community.

      In some ways, Mezzanine resembles tools such as Wordpress that
      provide an intuitive interface for managing pages, blog posts,
      form data, store products, and other types of content. But
      Mezzanine is also different.  Unlike many other platforms that
      make extensive use of modules or reusable applications,
      Mezzanine provides most of its functionality by default. This
      approach yields a more integrated and efficient platform.
    '';
    homepage = "http://mezzanine.jupo.org/";
    downloadPage = "https://github.com/stephenmcd/mezzanine/releases";
    license = licenses.bsd2;
    maintainers = with maintainers; [ prikhi ];
    platforms = platforms.unix;
  };
}
