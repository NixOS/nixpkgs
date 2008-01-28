args:
args.stdenv.lib.listOfListsToAttrs [
	[ "3.08.0" (import ./3.08.0.nix (args // {stdenv = args.stdenv34;})) ]
	[ "3.09.1" (import ./3.09.1.nix args) ]
	[ "3.10.0" (import ./3.10.0.nix (args // {stdenv = args.stdenvUsingSetupNew2;})) ]
	[ "default" (import ./3.09.1.nix args) ]
]
