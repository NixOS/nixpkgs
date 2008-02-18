origArgs:
let
  args = origArgs // { version = "4.0.1"; };
in
rec {
  fullargs = args // { kdelibs = libs; kdepimlibs = pimlibs; kdebase = base; kderuntime = runtime; };
  libs = import ./libs args;
  l10n = import ./l10n (args // {kdelibs = libs;});
  pimlibs = import ./pimlibs args;
  graphics = import ./graphics args;
  multimedia = import ./multimedia args;
  toys = import ./toys args;
  network = import ./network args;
  utils = import ./utils args;
  games = import ./games args;
  edu = import ./edu args;
  base = import ./base args;
  runtime = import ./runtime args;
  workspace = import ./workspace args;
  extragear_plasma = import ./extragear args;
  support = import ./support args;
  decibel = import ./decibel args;
# kdepim is not included in KDE-4.0.1, building from svn
  pim = import ./pim args;

  env = kde_pkgs: with args; [ (runCommand "kde-env"
  {
	  KDEDIRS = lib.concatStringsSep ":" (kde_pkgs ++ support.all);
	  scriptName = "echo-kde-dirs";
  }
  "
  ensureDir \${out}/bin
  scriptPath=\${out}/bin/\${scriptName}
  echo \"#!/bin/sh\" > \${scriptPath}
  echo \"echo -n export KDEDIRS=\${KDEDIRS}\" >> \${scriptPath}
  chmod +x \${scriptPath}
  ")] ++ kde_pkgs ++ support.all ++ [shared_mime_info qt xprop xset];
}
