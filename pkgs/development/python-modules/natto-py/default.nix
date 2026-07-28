{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cffi,
  mecab,
  unittestCheckHook,
  pyyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "natto-py";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "buruzaemon";
    repo = "natto-py";
    tag = finalAttrs.version;
    hash = "sha256-G7IYv5MNVfsTcTKQIMRAP9apTrMUo9+JnM3OWcV35X8=";
  };

  # natto-py discovers MeCab at run time by shelling out to `mecab -D` for the
  # system dictionary's charset and to `mecab-config --libs-only-L` for the
  # directory containing libmecab. Neither command is on PATH for importers of
  # this library, so hardcode both. The MECAB_CHARSET and MECAB_PATH
  # environment variables are still consulted first, so users can point
  # natto-py at a different MeCab installation.
  postPatch = ''
    substituteInPlace natto/environment.py \
      --replace-fail "['mecab', '-D']" "['${lib.getExe' mecab "mecab"}', '-D']" \
      --replace-fail "['mecab-config', '--libs-only-L']" "['${lib.getExe' mecab "mecab-config"}', '--libs-only-L']"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    cffi
  ];

  nativeCheckInputs = [
    unittestCheckHook
    # The test suite shells out to a bare `mecab` for `-v`, `-D` and `-P`, and
    # to `mecab-config`, so it needs them on PATH even though the library
    # itself no longer looks them up there.
    mecab
    pyyaml
  ];

  # tests/__init__.py refuses to run unless both variables are set; it does not
  # use the autodetection patched above.
  preCheck = ''
    export MECAB_PATH="${lib.getLib mecab}/lib/libmecab${stdenv.hostPlatform.extensions.sharedLibrary}"
    export MECAB_CHARSET="utf8"
  '';

  pythonImportsCheck = [ "natto" ];

  meta = {
    homepage = "https://github.com/buruzaemon/natto-py";
    changelog = "https://raw.githubusercontent.com/buruzaemon/natto-py/${finalAttrs.src.tag}/CHANGELOG";
    description = "Python binding to MeCab, the Japanese part-of-speech and morphological analyzer";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.imalison ];
  };
})
