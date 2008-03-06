{
# each repository has 
# a type, url and maybe a tag
# you can add group names to update some repositories at once (needs some testing)
# see nix_repository_manager expression in all-packages.nix

http =  { type= "darcs"; url="http://darcs.haskell.org/http/"; group="happs"; };
syb_with_class =  { type="darcs"; url="http://happs.org/HAppS/syb-with-class"; group="happs"; };
happs_data =  { type="darcs"; url=http://happs.org/repos/HAppS-Data; group="happs"; };
happs_util =  { type="darcs"; url=http://happs.org/repos/HAppS-Util; group="happs"; };
happs_state =  { type="darcs"; url=http://happs.org/repos/HAppS-State; group="happs"; };
happs_plugins =  { type="darcs"; url=http://happs.org/repos/HAppS-Plugins; group="happs"; };
happs_ixset =  { type="darcs"; url=http://happs.org/repos/HAppS-IxSet; group="happs"; };
happs_server =  { type="darcs"; url=http://happs.org/repos/HAppS-HTTP; group="happs"; };
cabal = { type="darcs"; url=http://darcs.haskell.org/cabal; };
}
