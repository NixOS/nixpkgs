{ lib
, beautifulsoup4
, bleach
, buildPythonPackage
, chardet
, django
, django_contrib_comments
, fetchPypi
, filebrowser_safe
, future
, grappelli_safe
, isPyPy
, pep8
, pillow
, pyflakes
, pythonOlder
, requests
, requests-oauthlib
, tzlocal
}:

buildPythonPackage rec {
  pname = "mezzanine";
  version = "6.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6" || isPyPy;

  src = fetchPypi {
    pname = "Mezzanine";
    inherit version;
    hash = "sha256-R/PB4PFQpVp6jnCasyPszgC294SKjLzq2oMkR2qV86s=";
  };

  buildInputs = [
    pyflakes
    pep8
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    bleach
    chardet
    django
    django_contrib_comments
    filebrowser_safe
    future
    grappelli_safe
    pillow
    requests
    requests-oauthlib
    tzlocal
  ];

  # Tests Fail Due to Syntax Warning, Fixed for v3.1.11+
  doCheck = false;
  # sed calls will be unecessary in v3.1.11+
  preConfigure = ''
    sed -i 's/==/>=/' setup.py
  '';

  LC_ALL = "en_US.UTF-8";

  meta = with lib; {
    description = "Content management platform built using the Django framework";
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

