{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-ctags3";
  version = "1.6.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "universal-ctags";
    repo = "python-ctags3";
    rev = finalAttrs.version;
    hash = "sha256-x+kyCB05VtOPlenkK5vOTjxXR24d436JpGvSd07PIbA=";
  };

  nativeBuildInputs = [ cython ];

  # Regenerating the bindings keeps later versions of Python happy
  postPatch = ''
    cython src/_readtags.pyx
  '';

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Ctags indexing python bindings";
    license = lib.licenses.lgpl3Plus;
  };
})
