{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
}:
buildPythonPackage (finalAttrs: {
  pname = "django-extra-views";
  version = "0.7.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "AndrewIngram";
    repo = "django-extra-views";
    tag = finalAttrs.version;
    hash = "sha256-MvZpnpusg3DVayunMxr/DwFCQvsOd5+QkI/SPdCl99c=";
  };

  meta = {
    description = "Django package which introduces additional class-based views in order to simplify common design patterns such as those found in the Django admin interface";
    homepage = "https://github.com/AndrewIngram/django-extra-views";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ RossComputerGuy ];
  };
})
