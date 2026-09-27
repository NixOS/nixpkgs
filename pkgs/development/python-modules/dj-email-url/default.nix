{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "dj-email-url";
  version = "1.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "migonzalvar";
    repo = "dj-email-url";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xjJZyQE/7zgFzFM3JnlkiT0juOv94o4X5398AqCn5Qg=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlags = [ "." ];

  meta = {
    description = "Use an URL to configure email backend settings in your Django Application";
    homepage = "https://github.com/migonzalvar/dj-email-url";
    # https://github.com/migonzalvar/dj-email-url/blob/master/LICENSE
    license =
      with lib.licenses;
      AND [
        bsd2
        cc-by-40
        cc0
      ];
    maintainers = [ ];
  };
})
