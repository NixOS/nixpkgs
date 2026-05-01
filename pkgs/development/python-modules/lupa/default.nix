{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  srcOnly,
  runCommand,

  # build-system
  cython,
  setuptools,

  # devendor
  lua5_1,
  lua5_2,
  lua5_3,
  lua5_4,
  lua5_5,
  luajit_2_0,
  luajit_2_1,
}:

buildPythonPackage (finalAttrs: {
  pname = "lupa";
  version = "2.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scoder";
    repo = "lupa";
    tag = "lupa-${finalAttrs.version}";
    # we fetch the vendored lua sources for gracefull de-vendor degredation when a new lua is added
    fetchSubmodules = true;
    hash = "sha256-XLBUQ1TrzWWST9RJdMTnpsceldDNzidnL82bixLhSRA=";
  };

  patches = [
    # The updated lua52 src has a radically changed makefile, matching lua53
    ./remove-lua52-special-case.patch
  ];

  # devendor/update the luas to newer patched versions
  postPatch = ''
    (
      set -x
      rm -rf third-party/lua51;    cp -r ${srcOnly lua5_1}     third-party/lua51
      rm -rf third-party/lua52;    cp -r ${srcOnly lua5_2}/src third-party/lua52
      rm -rf third-party/lua53;    cp -r ${srcOnly lua5_3}/src third-party/lua53
      rm -rf third-party/lua54;    cp -r ${srcOnly lua5_4}/src third-party/lua54
      rm -rf third-party/lua55;    cp -r ${srcOnly lua5_5}/src third-party/lua55
      rm -rf third-party/luajit20; cp -r ${srcOnly luajit_2_0} third-party/luajit20
      rm -rf third-party/luajit21; cp -r ${srcOnly luajit_2_1} third-party/luajit21
      chmod -R +w third-party/*
    )
  '';

  build-system = [
    cython
    setuptools
  ];

  pythonImportsCheck = [ "lupa" ];

  # this helps us discover new lua versions when bumping, without blocking mass python-updates
  passthru.tests.expected-third-party = runCommand "lupa-expected-third-party" { } ''
    declare -a expected=( lua51 lua52 lua53 lua54 lua55 luajit20 luajit21 )

    declare -a found_paths=( ${finalAttrs.src}/third-party/* )
    declare -a found=("''${found_paths[@]##*/}")
    if [[ "''${found[*]}" != "''${expected[*]}" ]]; then
      echo >&2 "./third-party/ contains unexpected paths!"
      echo >&2 "expected: ''${expected[*]}"
      echo >&2 "found:    ''${found[*]}"
      exit 1
    else
      touch $out
    fi
  '';

  meta = {
    description = "Lua in Python";
    homepage = "https://github.com/scoder/lupa";
    changelog = "https://github.com/scoder/lupa/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
