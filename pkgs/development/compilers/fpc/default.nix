args:
if ((args ? startFPC) && (args.startFPC != null))
	then 
args.stdenv.mkDerivation {
  name = "fpc-2.0.4";

  src = args.
	fetchurl {
		url = ftp://ftp.chg.ru/pub/lang/pascal/fpc/dist/source-2.0.4/fpcbuild-2.0.4.tar.gz;
		sha256 = "0sxgmslxy891why3d5pwn7zh4w3wj75apmhc7l5czmfhn3f0gcsc";
	};

  buildInputs = [args.startFPC args.gawk];

  installFlags = "INSTALL_PREFIX=\${out}";
  postInstall = "ln -fs $out/lib/fpc/*/ppc386 $out/bin;
	mkdir -p $out/lib/fpc/etc/ ;
	$out/lib/fpc/*/samplecfg $out/lib/fpc/2.* $out/lib/fpc/etc/;";

  meta = {
    description = "
	Free Pascal Compiler from a source distribution.
";
  };
} else (import ./default.nix (args // {startFPC = (import ./binary.nix args);}))
