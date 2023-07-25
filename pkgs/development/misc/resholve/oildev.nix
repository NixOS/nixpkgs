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
  cmark
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
    version = "2022-09-01";
    src = fetchFromGitHub {
      owner = "oilshell";
      repo = "py-yajl";
      rev = "72686b0e2e9d13d3ce5fefe47ecd607c540c90a3";
      hash = "sha256-H3GKN0Pq1VFD5+SWxm8CXUVO7zAyj/ngKVmDaG/aRT4=";
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
      # rev == present HEAD of release/0.14.0
      rev = "3d0427e222f7e42ae7be90c706d7fde555efca2e";
      hash = "sha256-XMoNkBEEmD6AwNSu1uSh3OcWLfy4/ADtRckn/Pj2cP4=";

      /*
        It's not critical to drop most of these; the primary target is
        the vendored fork of Python-2.7.13, which is ~ 55M and over 3200
        files, dozens of which get interpreter script patches in fixup.

        Note: -f is necessary to keep it from being a pain to update
        hash on rev updates. Command will fail w/o and not print hash.
      */
      postFetch = ''
        rm -rf $out/{Python-2.7.13,metrics,py-yajl,rfc,gold,web,testdata,services,demo,devtools}
      '';
    };

    # patch to support a python package, pass tests on macOS, drop deps, etc.
    patchSrc = fetchFromGitHub {
      owner = "abathur";
      repo = "nix-py-dev-oil";
      rev = "v0.14.0.0";
      hash = "sha256-U6uR8G6yB2xwuDE/fznco23mVFSVdCxPUNdCRYz4Mj8=";
    };
    patches = [
      "${patchSrc}/0001-add_setup_py.patch"
      "${patchSrc}/0002-add_MANIFEST_in.patch"
      "${patchSrc}/0004-disable-internal-py-yajl-for-nix-built.patch"
      "${patchSrc}/0006-disable_failing_libc_tests.patch"
      "${patchSrc}/0007-namespace_via_init.patch"
      "${patchSrc}/0009-avoid_nix_arch64_darwin_toolchain_bug.patch"
      "${patchSrc}/0010-disable-line-input.patch"
      "${patchSrc}/0011-disable-fanos.patch"
      "${patchSrc}/0012-disable-doc-cmark.patch"
    ];

    configureFlags = [
      "--without-readline"
    ];

    nativeBuildInputs = [ re2c file makeWrapper ];

    propagatedBuildInputs = [ six typing py-yajl ];

    doCheck = true;

    preBuild = ''
      build/dev.sh all
    '';

    postPatch = ''
      patchShebangs asdl build core doctools frontend pyext oil_lang
      substituteInPlace pyext/fastlex.c --replace '_gen/frontend' '../_gen/frontend'
      substituteInPlace core/main_loop.py --replace 'import fanos' '# import fanos'
      rm cpp/stdlib.h # keep modules from finding the wrong stdlib?
      # work around hard parse failure documented in oilshell/oil#1468
      substituteInPlace osh/cmd_parse.py --replace 'elif self.c_id == Id.Op_LParen' 'elif False'
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

    # not exhaustive; sample what resholve uses as a sanity check
    pythonImportsCheck = [
      "oil"
      "oil.asdl"
      "oil.core"
      "oil.frontend"
      "oil._devbuild"
      "oil._devbuild.gen.id_kind_asdl"
      "oil._devbuild.gen.syntax_asdl"
      "oil.tools.osh2oil"
    ];

    meta = {
      license = with lib.licenses; [
        psfl # Includes a portion of the python interpreter and standard library
        asl20 # Licence for Oil itself
      ];
    };
  };
}
