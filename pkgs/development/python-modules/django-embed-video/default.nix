{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  setuptools,
  setuptools-scm,
  readme,
  django,
  requests,

  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-embed-video";
  version = "1.4.11";
  __structuredAttrs = true;

  pyproject = true;

  build-system = [
    setuptools
    setuptools-scm
    readme
  ];

  dependencies = [
    django
    requests
  ];

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-embed-video";
    tag = finalAttrs.version;
    hash = "sha256-aftT558x/ffbfotzPfmG2ByDBlvV4m36XD7WMzRIBXw=";
  };

  pythonImportsCheck = [ "embed_video" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Django app for easy embedding YouTube and Vimeo videos and music from SoundCloud";
    homepage = "https://github.com/jazzband/django-embed-video";
    changelog = "https://github.com/jazzband/django-embed-video/blog/${finalAttrs.src.rev}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ grindhold ];
  };
})
