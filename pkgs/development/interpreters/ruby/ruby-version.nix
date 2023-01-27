# Contains the ruby version heuristics
{ lib }:

let
  # The returned set should be immutable
  rubyVersion = major: minor: tiny: tail:
    rec {
      inherit major minor tiny tail;

      # Contains the patch number "223" if tail is "p223" or null
      patchLevel =
        let
          p = lib.removePrefix "p" tail;
          isPosInt = num:
            0 == lib.stringLength
              (lib.replaceStrings
              ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9"]
              [""  ""  ""  ""  ""  ""  ""  ""  ""  "" ]
              num);
        in
          if lib.hasPrefix "p" tail && isPosInt p then p
          else null;

      # Shortcuts
      majMin = "${major}.${minor}";
      majMinTiny = "${major}.${minor}.${tiny}";

      # Ruby separates lib and gem folders by ABI version which isn't very
      # consistent.
      libDir =
        if lib.versionAtLeast majMinTiny "2.1.0" then
          "${majMin}.0"
        else if lib.versionAtLeast majMinTiny "2.0.0" then
          "2.0.0"
        else if lib.versionAtLeast majMinTiny "1.9.1" then
          "1.9.1"
        else
          throw "version ${majMinTiny} is not supported";

      # How ruby releases are tagged on github.com/ruby/ruby
      gitTag =
        let
          base = "v${major}_${minor}_${tiny}";
        in
          if patchLevel != null then
            "${base}_${patchLevel}"
          else
            if tail != "" then
              "${base}_${tail}"
            else
              base;

      # Implements the builtins.toString interface.
      __toString = self:
        self.majMinTiny + (
          if self.patchLevel != null then
            "-p${self.patchLevel}"
          else if self.tail != "" then
            "-${self.tail}"
          else "");
    };
in
  rubyVersion
