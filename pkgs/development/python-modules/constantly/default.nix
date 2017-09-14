{ stdenv, buildPythonPackage, fetchurl
}:
buildPythonPackage rec {
  pname = "constantly";
  name = "${pname}-${version}";
  version = "15.1.0";

  src = fetchurl {
    url = "mirror://pypi/c/constantly/${name}.tar.gz";
    sha256 = "0dgwdla5kfpqz83hfril716inm41hgn9skxskvi77605jbmp4qsq";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/twisted/constantly;
    description = "symbolic constant support";
    license = licenses.mit;
    maintainers = [ ];
  };
}
