{ neko, buildHaxeLib, withCommas, firetongue, spinehaxe, nape, poly2trihx, hscript, systools, task, openfl_3_6 }:

rec {
  flixel = buildHaxeLib {
    libname = "flixel";
    version = "4.2.1";
    sha256 = "00c0rg6myj1nwhgwsvqqpj0fsbvfz8piza7fl3mm69adcf4661fr";
    propagatedBuildInputs = [ openfl_3_6 ];
    meta.description = "HaxeFlixel is a 2D game engine based on OpenFL that delivers cross-platform games";
  };

  flixel-ui = buildHaxeLib {
    libname = "flixel-ui";
    version = "2.2.0";
    sha256 = "0b0rs6xfzfhnljsq4vgi74m8hzbsv79z14rsrl1dg6r5xfd69rgl";
    propagatedBuildInputs = [ flixel ];
    meta.description = "UI library for Flixel";
  };

  flixel-tools = buildHaxeLib {
    libname = "flixel-tools";
    version = "1.3.0";
    sha256 = "1w1x53g82aq9c93wh109nc4l6ggn7q0cpcakm69zx7wf93cq49kc";
    propagatedBuildInputs = [ flixel ];
    meta.description = "Command-Line tools for the HaxeFlixel game engine";
  };

  flixel-templates = buildHaxeLib {
    libname = "flixel-templates";
    version = "2.4.1";
    sha256 = "08a62gbx5r79819c69dhyzxh3cgm1w34ic1z3fihhl5ik4wdyc8n";
    propagatedBuildInputs = [ flixel ];
    meta.description = "Templates for HaxeFlixel projects";
  };

  flixel-addons = buildHaxeLib {
    libname = "flixel-addons";
    version = "2.4.1";
    sha256 = "0322vpkcvnzv35famp240p2lz6x65kkirns5qmvaqxbj845q09bi";
    propagatedBuildInputs = [ flixel ];
    meta.description = "Set of useful, additional classes for HaxeFlixel";
  };

  flixel-demos = buildHaxeLib rec {
    libname = "flixel-demos";
    version = "2.4.0";
    sha256 = "01dxknl4gr5dq8m9xwmdsp83vdkv4iirwg6w908cqx5254wn0hyr";
    meta.description = "Demo Projects for HaxeFlixel";
    propagatedBuildInputs = [ neko flixel flixel-ui flixel-addons firetongue nape spinehaxe poly2trihx hscript systools task ];
    postFixup = ''
      export HOME=$(mktemp -d)       # for "lime" to create working dir

      for demo in */*; do
        ( cd "$out/lib/haxe/${withCommas libname}/${withCommas version}/$demo"
          lime build html5 -verbose
          #lime build linux -verbose # works but compiles too slow
          lime build neko -verbose
          rm -rf Export/linux*/cpp/release/obj )
      done
    '';
  };

}