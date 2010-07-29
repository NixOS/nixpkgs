args : with args;
	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
			fetchurl {
				url = mirror://sourceforge/libdbi-drivers/libdbi-drivers-0.8.2-1.tar.gz;
				sha256 = "1bflwl1k3rf1h8clx3zv5pxnm5hbhq6izikv0phkss3qxkjm61ap";
			};

		buildInputs = [libdbi]  
		++(if args ? mysql then [args.mysql] else [])
		++(if args ? sqlite then [args.sqlite] else [])
		;
		configureFlags = [
			" --enable-libdbi "
			" --with-dbi-incdir=${libdbi}/include " 
			" --with-dbi-libdir=${libdbi}/lib " 
		]
		++ (if args ? mysql then [
			" --with-mysql "
			" --with-mysql-incdir=${args.mysql}/include/mysql " 
			" --with-mysql-libdir=${args.mysql}/lib/mysql " 
		] else [])
		++ (if args ? sqlite then [
			" --with-sqlite "
			" --with-sqlite-incdir=${args.sqlite}/include/sqlite " 
			" --with-sqlite-libdir=${args.sqlite}/lib/sqlite " 
		] else [])
		;
	};
	in with localDefs;
stdenv.mkDerivation rec {
	name = "libdbi-0.8.2-1";
	builder = writeScript (name + "-builder")
		(textClosure localDefs [doConfigure doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "DB independent interface to DB; DB drivers (mysql only for now)";
		inherit src;
	};
}
