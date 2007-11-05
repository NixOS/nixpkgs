args : with args;
	with builderDefs {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://www.cosc.canterbury.ac.nz/greg.ewing/python/Pyrex/oldtar/Pyrex-0.9.6.tar.gz;
		sha256 = "1i0mrv2a3ihnj5mjf07aic7nlps9qap57j477m8ajwhhwx9vwlxy";
	};
		buildInputs = [python];
		configureFlags = [];
	} null; /* null is a terminator for sumArgs */
	with stringsWithDeps;
stdenv.mkDerivation rec {
	name = "Pyrex-"+version;
	builder = writeScript (name + "-builder")
		(textClosure [installPythonPackage doForceShare]);
	meta = {
		description = "
	Python package compiler or something like that.	
";
	};
}
