{ stdenv, fetchurl, builderDefs, unzip, clisp }:
	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://www.lambdassociates.org/Download/Qi9.1.zip;
			sha256 = "1j584i7pj38rnlf7v9njfdwc6gc296v5friw2887dsw34dmwyg3f";
		};
		buildInputs = [ unzip clisp];
		configureFlags = [];
	};
	in with localDefs;
let 
	shell=stdenv.shell;
in
let 
	allBuild = fullDepEntry ("
		(sleep 0.1; echo ) | clisp install.txt;
		(sleep 0.1; echo -e '1\n(quit)\n' ) | sh Qi-Linux-CLisp 
		mkdir -p \$out/share
		mkdir -p \$out/bin
		cp -r . \$out/share/Qi-9.1
		echo -e '#! ${shell}
		arg1=\${1:-'\$out'/share/Qi-9.1/startup.txt}
		shift
		clisp -M '\$out'/share/Qi-9.1/lispinit.mem \$arg1 \"\$@\"\\n' > \$out/bin/qi
		chmod a+x \$out/bin/qi
	") [ addInputs minInit doUnpack defEnsureDir];
in
stdenv.mkDerivation rec {
	name = "Qi-9.1";
	builder = writeScript (name + "-builder")
		(textClosure localDefs [allBuild doForceShare doPropagate]);
	meta = {
		description = "Qi - next generation on top of Common Lisp";
		inherit src;
	};
}
