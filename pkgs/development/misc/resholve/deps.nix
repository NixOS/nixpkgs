{ stdenv
, fetchFromGitHub
, makeWrapper
, # re2c deps
  autoreconfHook
, # py-yajl deps
  git
, # oil deps
  readline
, cmark
, python27
, file
, glibcLocales
, oilPatches ? [ ]
}:

/*
Notes on specific dependencies:
- if/when python2.7 is removed from nixpkgs, this may need to figure
  out how to build oil's vendored python2
- I'm not sure if glibcLocales is worth the addition here. It's to fix
  a libc test oil runs. My oil fork just disabled the libc tests, but
  I haven't quite decided if that's the right long-term call, so I
  didn't add a patch for it here yet.
*/

rec {
  # had to add this as well; 1.3 causes a break here; sticking
  # to oil's official 1.0.3 dep for now.
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
    pname = "oil-pyyajl";
    version = "unreleased";
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

  # resholve's primary dependency is this developer build of the oil shell.
  oildev = python27.pkgs.buildPythonPackage rec {
    pname = "oil";
    version = "undefined";

    src = fetchFromGitHub {
      owner = "oilshell";
      repo = "oil";
      rev = "ea80cdad7ae1152a25bd2a30b87fe3c2ad32394a";
      sha256 = "0pxn0f8qbdman4gppx93zwml7s5byqfw560n079v68qjgzh2brq2";

      /*
      This feels a little dumb; I assume it's wrongish. I was hoping
      to be able to filter the source down to knock out parts of the
      source that I'm not using, but I get errors just trying to get
      *anything* working with the approaches commented out below.

      On IRC eadwu[m] suggested dropping them in extraPostFetch.

      It's not critical to drop most of these; the primary target is
      the vendored fork of Python-2.7.13, which is ~ 55M and over 3200
      files, dozens of which get interpreter script patches in fixup.
      */
      extraPostFetch = ''
        #find . -maxdepth 1 -type d | sort
        rm -rf Python-2.7.13 benchmarks metrics py-yajl rfc gold web testdata services demo devtools cpp
        # find . -maxdepth 1 -type d | sort
      ''; # breakers: doc, pgen2, vendor
    };

    # src = stdenv.lib.cleanSourceWith {
    #   src = fetchFromGitHub {
    #     owner = "oilshell";
    #     repo = "oil";
    #     rev = "ea80cdad7ae1152a25bd2a30b87fe3c2ad32394a";
    #     sha256 = "0pxn0f8qbdman4gppx93zwml7s5byqfw560n079v68qjgzh2brq2";
    #   };
    #   filter = stdenv.lib.cleanSourceFilter;
    # };

    # src = stdenv.lib.sourceByRegex (fetchFromGitHub {
    #   owner = "oilshell";
    #   repo = "oil";
    #   rev = "ea80cdad7ae1152a25bd2a30b87fe3c2ad32394a";
    #   sha256 = "0pxn0f8qbdman4gppx93zwml7s5byqfw560n079v68qjgzh2brq2";
    # }) [".*"];

    # TODO: not sure why I'm having to set this for nix-build...
    #       can anyone tell if I'm doing something wrong?
    SOURCE_DATE_EPOCH = 315532800;


    # These aren't, strictly speaking, nix/nixpkgs specific, but I've
    # had hell upstreaming them. Pulling from resholve source and
    # passing in from resholve.nix
    patches = oilPatches;

    buildInputs = [ readline cmark py-yajl makeWrapper ];

    nativeBuildInputs = [ re2c file ];

    # runtime deps
    propagatedBuildInputs = with python27.pkgs; [ python27 six typing ];

    doCheck = true;
    dontStrip = true;

    preBuild = ''
      build/dev.sh all
    '';

    # Patch shebangs so Nix can find all executables
    postPatch = ''
      patchShebangs asdl build core doctools frontend native oil_lang
    '';

    _NIX_SHELL_LIBCMARK = "${cmark}/lib/libcmark${stdenv.hostPlatform.extensions.sharedLibrary}";

    # See earlier note on glibcLocales
    LOCALE_ARCHIVE = stdenv.lib.optionalString (stdenv.buildPlatform.libc == "glibc") "${glibcLocales}/lib/locale/locale-archive";

    meta = {
      description = "A new unix shell";
      homepage = "https://www.oilshell.org/";
      license = with stdenv.lib.licenses; [
        psfl # Includes a portion of the python interpreter and standard library
        asl20 # Licence for Oil itself
      ];
    };
  };
}
