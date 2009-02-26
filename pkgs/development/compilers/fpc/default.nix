args:
if ((args ? startFPC) && (args.startFPC != null))
	then 
with args;
stdenv.mkDerivation {
  name = "fpc-2.2.2";

  src = fetchurl {
		url = ftp://freepascal.stack.nl/pub/fpc/dist/source-2.2.2/fpcbuild-2.2.2.tar.gz;
		sha256 = "0d73b119e029382052fc6615034c4b5ee3ec66fa6cc45648f1f07cfb2c1058f1";
	};

  buildInputs = [startFPC gawk];

  preConfigure = (if system == "i686-linux" || system == "x86_64-linux" then ''
  	sed -e "s@'/lib/ld-linux[^']*'@'''@" -i fpcsrc/compiler/systems/t_linux.pas
  '' else "");

  makeFlags = "NOGDB=1";

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
