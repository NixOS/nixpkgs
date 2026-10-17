{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  breathe,
  sphinx,
  beautifulsoup4,
  lxml,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "exhale";
  version = "0.3.7";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "svenevs";
    repo = "exhale";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I7Q2vKLT/h35xX87FugyvxSTESnO3+LFLUX9kZOPI0I=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    breathe
    sphinx
    beautifulsoup4
    lxml
    six
  ];

  pythonImportsCheck = [
    "exhale"
  ];

  meta = {
    description = "Automatic C++ library api documentation generation: breathe doxygen in and exhale it out";
    homepage = "https://github.com/svenevs/exhale";
    changelog = "https://github.com/svenevs/exhale/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
