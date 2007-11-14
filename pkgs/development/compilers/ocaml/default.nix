args:
rec {
	default = v_3_09_1;
	v_3_08_0 = import ./3.08.0.nix (args // {stdenv = args.stdenv34;});
	v_3_09_1 = import ./3.09.1.nix args;
	v_3_10_0 = import ./3.10.0.nix (args // {stdenv = args.stdenvUsingSetupNew2;});
}
