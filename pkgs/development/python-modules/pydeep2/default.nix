{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  setuptools,
  ssdeep,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydeep2";
  version = "0.5.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "JakubOnderka";
    repo = "pydeep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qeE+ckYIDOeXaDC3Rxh4LmS0oN+Tqvjwe2tGDDt7YgA=";
  };

  build-system = [ setuptools ];

  buildInputs = [ ssdeep ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"/usr/local/include/"' '"${ssdeep}/include"' \
      --replace-fail '"/usr/local/lib/"' '"${ssdeep}/lib"'
  '';

  pythonImportsCheck = [ "pydeep" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python bindings for ssdeep";
    homepage = "https://github.com/JakubOnderka/pydeep";
    changelog = "https://github.com/JakubOnderka/pydeep/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
