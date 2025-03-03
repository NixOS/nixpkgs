{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pandocfilters,
  psutil,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pandoc-xnos";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tomduck";
    repo = "pandox-xnos";
    tag = version;
    hash = "sha256-beiGvN0DS6s8wFjcDKozDuwAM2OApX3lTRaUDRUqLeU=";
  };

  patches = [
    # This patch fix the Pandoc 3 compatibility.
    # See: https://github.com/tomduck/pandoc-xnos/pull/29
    (fetchpatch {
      url = "https://github.com/tomduck/pandoc-xnos/commit/284474574f51888be75603e7d1df667a0890504d.patch";
      hash = "sha256-j6xaFXo3jtXGPL58aIp8RTqeQZhJ8cVKL/iUbUhXBF0=";
    })
  ];

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "psutil" ];

  dependencies = [
    pandocfilters
    psutil
  ];

  pythonImportsCheck = [ "pandocxnos" ];

  # tests need some patching
  doCheck = false;

  meta = {
    description = "Pandoc filter suite providing facilities for cross-referencing in markdown documents";
    mainProgram = "pandoc-xnos";
    homepage = "https://github.com/tomduck/pandoc-xnos";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ppenguin ];
  };
}
