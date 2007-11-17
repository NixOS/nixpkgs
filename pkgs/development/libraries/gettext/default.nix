args:
builtins.listToAttrs [
	{ name = "recurseForDerivations"; value = true; }
	{ name = "0.14.6"; value = (import ./0.14.6.nix) args; }
	{ name = "0.15"; value = (import ./0.15.nix) args; }
	{ name = "0.16.x"; value = (import ./0.16.x.nix) args; }
]
