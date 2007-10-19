args:
if ((args ? startFPC) && (args.startFPC != null))
	then 
args.stdenv.mkDerivation {
  name = "fpc-2.2.0";

  src = args.
	fetchurl {
		url = ftp://freepascal.stack.nl/pub/fpc/dist/source-2.2.0/fpcbuild-2.2.0.tar.gz;
		sha256 = "0pvsdmimknkgy8jgdz9kd7w5bs9fy5ynrgswpk0ib6x0y26zxijm";
	};

  buildInputs = [args.startFPC args.gawk];

  installFlags = "INSTALL_PREFIX=\${out}";
  postInstall = "ln -fs $out/lib/fpc/*/ppc386 $out/bin;
	mkdir -p $out/lib/fpc/etc/ ;
	$out/lib/fpc/*/samplecfg $out/lib/fpc/2.2.0 $out/lib/fpc/etc/;";

  meta = {
    description = "
	Free Pascal Compiler from a source distribution.
";
  };
} else (import ./default.nix (args // {startFPC = (import ./binary.nix args);}))
