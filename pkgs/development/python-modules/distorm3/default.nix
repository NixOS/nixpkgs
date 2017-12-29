{ stdenv, buildPythonPackage, fetchurl }:

buildPythonPackage rec {
  pname = "distorm3";
  version = "3.3.4";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/d/${pname}/${name}.zip";
    sha256 = "1bh9xdiz9mkf9lfffimfn3hgd0mh60y7wl1micgkxzpl7hnxrpd4";
  };

  # no tests included
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Powerful Disassembler Library For x86/AMD64";
    homepage = https://github.com/gdabah/distorm;
    license = licenses.bsd3;
  };
}
