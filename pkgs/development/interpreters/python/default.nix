args:
args.stdenv.lib.listOfListsToAttrs [
	[ "default"  (import ./2.4.nix args) ]
	[ "2.4"  (import ./2.4.nix args) ]
	[ "2.5" (import ./2.5 args) ]
]
