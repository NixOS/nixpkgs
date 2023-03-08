{ resholvePackage
, lib
, fetchFromGitHub
, fetchurl
, perl
, perlPackages
, sharnessExtensions ? {}
, bash
, coreutils
, diffutils
, findutils
, ncurses
, gnused
}:

resholvePackage rec {
  pname = "sharness";
  version = "1.1.0-dev";

  src = fetchFromGitHub {
    owner = "chriscool";
    repo = pname;
    rev = "3f238a740156dd2082f4bd60ced205e05894d367"; # 2020-12-09
    sha256 = "FCYskpIqkrpNaWCi2LkhEkiow4/rXLe+lfEWNUthLUg=";
  };

  # Used for testing
  nativeBuildInputs = [ perl perlPackages.IOTty ];

  outputs = [ "out" "doc" ];

  makeFlags = [ "prefix=$(out)" ];

  extensions = lib.mapAttrsToList (k: v: "${k}.sh ${v}") sharnessExtensions;

  postInstall = lib.optionalString (sharnessExtensions != {}) ''
    extDir=$out/share/sharness/sharness.d
    mkdir -p "$extDir"
    linkExtensions() {
      set -- $extensions
      while [ $# -ge 2 ]; do
        ln -s "$2" "$extDir/$1"
        shift 2
      done
    }
    linkExtensions
  '';

  doCheck = true;

  solutions = {
    sharness = {
      scripts = [
        "share/sharness/sharness.sh"
        "share/sharness/lib-sharness/functions.sh"
        "share/sharness/lib-sharness/aggregate-results.sh"
      ];
      # not bash specific, but the source seems to ~prefer bash?
      # it sounds like you just source it, so this is mostly doc anyways
      interpreter = "${bash}/bin/bash";
      inputs = [
        coreutils
        bash
        diffutils
        findutils
        ncurses
        gnused
      ];
      fix = {
        "$SHELL_PATH" = [ "sh" ];
        "$TEST_CMP" = [ "'diff -u'" ];
      };
      keep = {
        source = [
          /*
          not 100% sure, but it looks like it'll dynamically locate either the
          store directory it's running from, or similar ~override paths in the
          code under test...
          */
          "$SHARNESS_TEST_SRCDIR"
          # file == individual files loaded from srcdir above
          "$file"
        ];
      };
      # TODO: drop when diffutils & ncurses are triaged in binlore / resholve
      # manually checked for likely-execed arguments for now
      execer = [
        "cannot:${diffutils}/bin/diff"
        "cannot:${ncurses}/bin/tput"
      ];
    };
  };

  meta = with lib; {
    description = "Portable shell library to write, run and analyze automated tests adhering to Test Anything Protocol (TAP)";
    homepage = "https://github.com/chriscool/sharness";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.spacefrogg ];
    platforms = platforms.unix;
  };
}
