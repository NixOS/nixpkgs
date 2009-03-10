args:
rec {
  fullargs = args // { kdelibs = libs; kdepimlibs = pimlibs; kdebase = base; kderuntime = runtime; };
  libs = import ./libs (args // { kdesupport = support; });
  pimlibs = import ./pimlibs (args // { kdelibs = libs; });
  graphics = import ./graphics (fullargs // { kdeworkspace = workspace; } );
  multimedia = import ./multimedia (fullargs // { kdeworkspace = workspace; } );
  toys = import ./toys (fullargs // { kdeworkspace = workspace; } );
  network = import ./network (fullargs // { kdeworkspace = workspace; } );
  utils = import ./utils (fullargs // { kdeworkspace = workspace; } );
  games = import ./games (fullargs // { kdeworkspace = workspace; } );
  edu = import ./edu (fullargs // { kdeworkspace = workspace; } );
  base = import ./base fullargs;
  runtime = import ./runtime fullargs;
  workspace = import ./workspace fullargs;
  extragear_plasma = import ./extragear (fullargs // { kdeworkspace = workspace; });
  support = import ./support args;
  decibel = import ./decibel fullargs;
  pim = import ./pim (fullargs // {kdeworkspace = workspace; });

  env = with args; runCommand "kde-env"
  {
	  KDEDIRS = lib.concatStringsSep ":" ([ libs pimlibs graphics multimedia
	  toys network utils games edu base runtime workspace extragear_plasma pim] ++
	  support.all);
	  scriptName = "echo-kde-dirs";
  }
  "
  ensureDir \${out}/bin
  scriptPath=\${out}/bin/\${scriptName}
  echo \"#!/bin/sh\" > \${scriptPath}
  echo \"echo -n export KDEDIRS=\${KDEDIRS}\" >> \${scriptPath}
  chmod +x \${scriptPath}
  ";
}
