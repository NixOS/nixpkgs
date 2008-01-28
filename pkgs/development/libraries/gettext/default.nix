args:
args.stdenv.lib.listOfListsToAttrs [
	[ "recurseForDerivations" true ]
	[ "0.14.6" (import ./0.14.6.nix args) ]
	[ "0.15" (import ./0.15.nix args) ]
	[ "0.16.x" (import ./0.16.x.nix args) ]
	[ "default" (import ./0.14.6.nix args) ]
]
