{ lib
, stdenv
, python27
, callPackage
, fetchFromGitHub
, makeWrapper
, # re2c deps
  autoreconfHook
, # py-yajl deps
  git
, # oil deps
  readline
, cmark
, file
, glibcLocales
, six
, typing
}:

rec {
  re2c = stdenv.mkDerivation rec {
    pname = "re2c";
    version = "1.0.3";
    sourceRoot = "${src.name}/re2c";
    src = fetchFromGitHub {
      owner = "skvadrik";
      repo = "re2c";
      rev = version;
      sha256 = "0grx7nl9fwcn880v5ssjljhcb9c5p2a6xpwil7zxpmv0rwnr3yqi";
    };
    nativeBuildInputs = [ autoreconfHook ];
    preCheck = ''
      patchShebangs run_tests.sh
    '';
  };

  py-yajl = python27.pkgs.buildPythonPackage rec {
    pname = "oil-pyyajl-unstable";
    version = "2019-12-05";
    src = fetchFromGitHub {
      owner = "oilshell";
      repo = "py-yajl";
      rev = "eb561e9aea6e88095d66abcc3990f2ee1f5339df";
      sha256 = "17hcgb7r7cy8r1pwbdh8di0nvykdswlqj73c85k6z8m0filj3hbh";
      fetchSubmodules = true;
    };
    # just for submodule IIRC
    nativeBuildInputs = [ git ];
  };

  /*
    Upstream isn't interested in packaging this as a library
    (or accepting all of the patches we need to do so).
    This creates one without disturbing upstream too much.
  */
  oildev = python27.pkgs.buildPythonPackage rec {
    pname = "oildev-unstable";
    version = "2021-07-14";

    src = fetchFromGitHub {
      owner = "oilshell";
      repo = "oil";
      # rev == present HEAD of release/0.8.12
      rev = "799c0703d1da86cb80d1f5b163edf9369ad77cf1";
      hash = "sha256-QNSISr719ycZ1Z0quxHWzCb3IvHGj9TpogaYz20hDM4=";

      /*
        It's not critical to drop most of these; the primary target is
        the vendored fork of Python-2.7.13, which is ~ 55M and over 3200
        files, dozens of which get interpreter script patches in fixup.

        Note: -f is necessary to keep it from being a pain to update
        hash on rev updates. Command will fail w/o and not print hash.
      */
      postFetch = ''
        rm -rf Python-2.7.13 benchmarks metrics py-yajl rfc gold web testdata services demo devtools cpp
      '';
    };

    # patch to support a python package, pass tests on macOS, etc.
    patchSrc = fetchFromGitHub {
      owner = "abathur";
      repo = "nix-py-dev-oil";
      rev = "v0.8.12.2";
      hash = "sha256-+dVxzPKMGNKFE+7Ggzx9iWjjvwW2Ow3UqmjjUud9Mqo=";
    };
    patches = [
      "${patchSrc}/0001-add_setup_py.patch"
      "${patchSrc}/0002-add_MANIFEST_in.patch"
      "${patchSrc}/0004-disable-internal-py-yajl-for-nix-built.patch"
      "${patchSrc}/0006-disable_failing_libc_tests.patch"
      "${patchSrc}/0007-namespace_via_init.patch"
      "${patchSrc}/0009-avoid_nix_arch64_darwin_toolchain_bug.patch"
    ];

    buildInputs = [ readline cmark py-yajl ];

    nativeBuildInputs = [ re2c file makeWrapper ];

    propagatedBuildInputs = [ six typing ];

    doCheck = true;

    preBuild = ''
      build/dev.sh all
    '';

    postPatch = ''
      patchShebangs asdl build core doctools frontend native oil_lang
    '';

    /*
    We did convince oil to upstream an env for specifying
    this to support a shell.nix. Would need a patch if they
    later drop this support. See:
    https://github.com/oilshell/oil/blob/46900310c7e4a07a6223eb6c08e4f26460aad285/doctools/cmark.py#L30-L34
    */
    _NIX_SHELL_LIBCMARK = "${cmark}/lib/libcmark${stdenv.hostPlatform.extensions.sharedLibrary}";

    # See earlier note on glibcLocales TODO: verify needed?
    LOCALE_ARCHIVE = lib.optionalString (stdenv.buildPlatform.libc == "glibc") "${glibcLocales}/lib/locale/locale-archive";

    # not exhaustive; just a spot-check for now
    pythonImportsCheck = [ "oil" "oil._devbuild" ];

    meta = {
      license = with lib.licenses; [
        psfl # Includes a portion of the python interpreter and standard library
        asl20 # Licence for Oil itself
      ];
    };
  };
}
