{ stdenv, fetchPypi, buildPythonPackage, swig, pcsclite, PCSC }:

buildPythonPackage rec {
  version = "1.9.8";
  pname = "pyscard";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15fh00z1an6r5j7hrz3jlq0rb3jygwf3x4jcwsa008bv8vpcg7gm";
  };

  postPatch = ''
    sed -e 's!"libpcsclite\.so\.1"!"${stdenv.lib.getLib pcsclite}/lib/libpcsclite.so.1"!' \
        -i smartcard/scard/winscarddll.c
  '';

  NIX_CFLAGS_COMPILE = "-isystem ${stdenv.lib.getDev pcsclite}/include/PCSC/";

  propagatedBuildInputs = [ pcsclite ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin PCSC;
  nativeBuildInputs = [ swig ];

  meta = {
    homepage = https://pyscard.sourceforge.io/;
    description = "Smartcard library for python";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ layus ];
  };
}
