{ lib
, python
, makeSetupHook
, makeWrapper }:

with lib;

makeSetupHook {
      deps = makeWrapper;
      substitutions.sitePackages = python.sitePackages;
      substitutions.executable = python.interpreter;
      substitutions.python = python.pythonForBuild;
      substitutions.pythonHost = python;
      substitutions.magicalSedExpression = let
        # Looks weird? Of course, it's between single quoted shell strings.
        # NOTE: Order DOES matter here, so single character quotes need to be
        #       at the last position.
        quoteVariants = [ "'\"'''\"'" "\"\"\"" "\"" "'\"'\"'" ]; # hey Vim: ''

        mkStringSkipper = labelNum: quote: let
          label = "q${toString labelNum}";
          isSingle = elem quote [ "\"" "'\"'\"'" ];
          endQuote = if isSingle then "[^\\\\]${quote}" else quote;
        in ''
          /^[a-z]?${quote}/ {
            /${quote}${quote}|${quote}.*${endQuote}/{n;br}
            :${label}; n; /^${quote}/{n;br}; /${endQuote}/{n;br}; b${label}
          }
        '';

        # This preamble does two things:
        # * Adds all required binary directories to PATH
        # * Adds all required libraries to sys.path via `site.addsitedir`. It also handles *.pth files.
        preamble = ''
          import os
          import sys
          import site
          import functools
          os.environ["PATH"] = ":".join(['"$([ -n "$program_PATH" ] && (echo "'$program_PATH'" | sed "s|:|','|g") || true)"']) + (":" + os.environ["PATH"] if os.environ.get("PATH") else "")
          functools.reduce(lambda k, p: site.addsitedir(p, k), ['"$([ -n "$program_PYTHONPATH" ] && (echo "'$program_PYTHONPATH'" | sed "s|:|','|g") || true)"'], site._init_pathinfo())
        '';

      in ''
        1 {
          :r
          /\\$|,$/{N;br}
          /__future__|^ |^ *(#.*)?$/{n;br}
          ${concatImapStrings mkStringSkipper quoteVariants}
          /^[^# ]/i ${replaceStrings ["\n"] [";"] preamble}
        }
      '';
} ./wrap.sh
