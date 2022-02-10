{ lib

, buildPythonPackage
, fetchPypi
, isPyPy
, pyflakes
, pep8
, django
, django_contrib_comments
, filebrowser_safe
, grappelli_safe
, bleach
, tzlocal
, beautifulsoup4
, requests
, requests_oauthlib
, future
, pillow
, chardet
}:

buildPythonPackage rec {
  version = "5.1.0";
  pname = "Mezzanine";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ce1117c81416d2e0a77981419312e200aec1cf3cb3ea9630083bd29e74bbb265";
  };

  disabled = isPyPy || lib.versionOlder django.version "1.11"
    || lib.versionAtLeast django.version "2.0";

  buildInputs = [ pyflakes pep8 ];
  propagatedBuildInputs = [ django django_contrib_comments filebrowser_safe grappelli_safe bleach tzlocal beautifulsoup4 requests requests_oauthlib future pillow chardet ];

  # Tests Fail Due to Syntax Warning, Fixed for v3.1.11+
  doCheck = false;
  # sed calls will be unecessary in v3.1.11+
  preConfigure = ''
    sed -i 's/==/>=/' setup.py
  '';

  LC_ALL="en_US.UTF-8";

  meta = with lib; {
    description = ''
      A content management platform built using the Django framework
    '';
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
    license = licenses.free;
    maintainers = with maintainers; [ prikhi ];
    platforms = platforms.unix;
    # mezzanine requires django-1.11. Consider overriding python package set to use django_1_11"
    broken = versionOlder django.version "1.11" || versionAtLeast django.version "2.0";
  };

}
