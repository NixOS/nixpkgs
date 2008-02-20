sha256: args: with args;
stdenv.mkDerivation rec {
	name = "libarchive-" + version;

	src = fetchurl {
		url = "${meta.homepage}/src/${name}.tar.gz";
    inherit sha256;
	};

	propagatedBuildInputs = [zlib bzip2 e2fsprogs];
  buildInputs = [sharutils];
  configureFlags = "--enable-shared --disable-static";

	meta = {
		description = "A library for reading and writing streaming archives";
    homepage = http://people.freebsd.org/~kientzle/libarchive;
	};
}
