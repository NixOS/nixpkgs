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
  version = "1.5.0";

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
    hash = "sha256-T9g3YMZFfn+NlbrBU/mroZ20NdAx5L8xRnxfQ1A4dM4=";
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
